import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:second/models/profile_result.dart';
import 'package:second/services/storage_service.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  /// Safely cast response.data to Map — returns null if it's a plain String
  /// (e.g. "Too Many Requests") so callers never crash on ['key'] access.
  Map<String, dynamic>? _safeMap(dynamic data) =>
      data is Map<String, dynamic> ? data : null;

  /// Fetches the complete user profile by calling all three endpoints
  /// This combines username, email, and photo into a single User object
  /// 
  /// Flow:
  /// 1. Get username from /api/v1/users/profile/username
  /// 2. Get email from /api/v1/users/profile/email
  /// 3. Get photo from /api/v1/users/profile/photo
  /// 4. Combine all data into a User object
  /// 5. Save to local storage
  Future<ProfileResult> getProfile() async {
    try {
      print('ProfileService: Fetching complete user profile...');

      // Load cached values first — used as fallback if any API call fails
      final cached = await _storage.getUserData();
      final String? userId   = await _storage.getUserId();
      String userName        = cached?['name']         ?? '';
      String userEmail       = cached?['email']        ?? '';
      String? userPhoto      = cached?['profileImage'];

      // ── Step 1: Username ──────────────────────────────────────────────
      try {
        final nameResponse = await _apiClient.get('/api/v1/users/profile/username');
        print('Username response status: ${nameResponse.statusCode}');
        print('Username response data: ${nameResponse.data}');

        if (nameResponse.statusCode == 200) {
          final body = _safeMap(nameResponse.data);
          final fetched = body?['data']?['name']?.toString() ?? '';
          if (fetched.isNotEmpty) userName = fetched;
          print('ProfileService: Extracted username = $userName');
        }
        // Non-200 (rate limit, server error, etc.) → keep cached value, don't crash
      } catch (e) {
        print('Error fetching username (keeping cached): $e');
      }

      // ── Step 2: Email ─────────────────────────────────────────────────
      try {
        final emailResponse = await _apiClient.get('/api/v1/users/profile/email');
        print('Email response status: ${emailResponse.statusCode}');
        print('Email response data: ${emailResponse.data}');

        if (emailResponse.statusCode == 200) {
          final body = _safeMap(emailResponse.data);
          final fetched = body?['data']?['email']?.toString() ?? '';
          if (fetched.isNotEmpty) userEmail = fetched;
        }
      } catch (e) {
        print('Error fetching email (keeping cached): $e');
      }

      // ── Step 3: Photo ─────────────────────────────────────────────────
      try {
        final photoResponse = await _apiClient.get('/api/v1/users/profile/photo');
        print('Photo response status: ${photoResponse.statusCode}');
        print('Photo response data: ${photoResponse.data}');

        if (photoResponse.statusCode == 200) {
          final body = _safeMap(photoResponse.data);
          final fetched = body?['data']?['photo']?.toString();
          if (fetched != null && fetched.isNotEmpty) userPhoto = fetched;
        }
      } catch (e) {
        print('Error fetching photo (keeping cached): $e');
      }

      // ── Build user ────────────────────────────────────────────────────
      final user = User(
        id: userId ?? '',
        email: userEmail,
        name: userName,
        profileImage: userPhoto,
      );

      // Only persist to cache when we actually have non-empty values
      // so we never overwrite good cached data with blanks
      if (userName.isNotEmpty || userEmail.isNotEmpty) {
        await _storage.saveUserData(
          id: userId ?? '',
          email: userEmail,
          name: userName,
          profileImage: userPhoto,
        );
      }

      print('ProfileService: Profile loaded — name: $userName, email: $userEmail');
      return ProfileResult(
        success: true,
        message: 'Profile loaded successfully',
        user: user,
      );

    } on DioException catch (e) {
      print('DioException in getProfile: ${e.type} — ${e.message}');
      if (e.response?.statusCode == 401) {
        return ProfileResult(success: false, message: 'Unauthorized. Please login again.');
      }
      return ProfileResult(success: false, message: 'Network error: ${e.message}');
    } catch (e) {
      print('Unknown error in getProfile: $e');
      return ProfileResult(success: false, message: 'An unexpected error occurred: $e');
    }
  }

  /// Updates the user's profile photo
  /// 
  /// @param photoUrl: The URL of the new photo (as a string)
  /// 
  /// Flow:
  /// 1. Send PATCH request to /api/v1/users/profile/updateuserphoto
  /// 2. Include the photo URL in the request body
  /// 3. Save the updated photo to local storage
  /// 4. Fetch the complete profile again to ensure consistency
  Future<ProfileResult> updateProfileImage(String filePath) async {
    try {
      print('ProfileService: Saving photo locally from: $filePath');

      // ── Step 1: Copy picked image to permanent app documents folder ──
      final appDir = await getApplicationDocumentsDirectory();
      final userId = await _storage.getUserId() ?? 'user';
      final localPath = '${appDir.path}/profile_$userId.jpg';
      await File(filePath).copy(localPath);
      print('ProfileService: Saved locally at $localPath');

      // ── Step 2: Save local path to SharedPreferences ──
      await _storage.saveProfileImage(localPath);

      // ── Step 3: Also try to notify backend (fire and forget — won't crash if it fails) ──
      try {
        final response = await _apiClient.patch(
          '/api/v1/users/profile/updateuserphoto',
          data: {'photo': localPath},
        );
        print('Backend notify status: ${response.statusCode}');
      } catch (e) {
        // Backend update is best-effort — local save already succeeded
        print('Backend notify failed (local save still succeeded): $e');
      }

      // ── Step 4: Build updated user from cache ──
      final cached = await _storage.getUserData();
      final user = User(
        id: await _storage.getUserId() ?? '',
        email: cached?['email'] ?? '',
        name: cached?['name'] ?? '',
        profileImage: localPath,
      );

      return ProfileResult(
        success: true,
        message: 'Profile image saved successfully',
        user: user,
      );
    } catch (e) {
      print('Error saving profile image locally: $e');
      return ProfileResult(
        success: false,
        message: 'Failed to save image: $e',
      );
    }
  }

  /// Helper method to get just the username
  Future<String?> getUsername() async {
    try {
      final response = await _apiClient.get('/api/v1/users/profile/username');
      final body = _safeMap(response.data);
      if (response.statusCode == 200 && body?['status'] == 'success') {
        return body!['data']['name'];
      }
      return null;
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }

  /// Helper method to get just the email
  Future<String?> getEmail() async {
    try {
      final response = await _apiClient.get('/api/v1/users/profile/email');
      final body = _safeMap(response.data);
      if (response.statusCode == 200 && body?['status'] == 'success') {
        return body!['data']['email'];
      }
      return null;
    } catch (e) {
      print('Error getting email: $e');
      return null;
    }
  }

  /// Helper method to get just the photo URL
  Future<String?> getPhoto() async {
    try {
      final response = await _apiClient.get('/api/v1/users/profile/photo');
      final body = _safeMap(response.data);
      if (response.statusCode == 200 && body?['status'] == 'success') {
        return body!['data']['photo'];
      }
      return null;
    } catch (e) {
      print('Error getting photo: $e');
      return null;
    }
  }
}

/// Result class for profile operations
/// Contains success status, message, and optional user data