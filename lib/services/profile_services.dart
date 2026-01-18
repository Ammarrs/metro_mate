import 'package:dio/dio.dart';
import 'package:second/models/profile_result.dart';
import 'package:second/services/storage_service.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

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

      String? userId;
      String userName = '';
      String userEmail = '';
      String? userPhoto;

      // Step 1: Get Username
      try {
        final nameResponse = await _apiClient.get('/api/v1/users/profile/username');
        print('Username response status: ${nameResponse.statusCode}');
        print('Username response data: ${nameResponse.data}');

        if (nameResponse.statusCode == 200 && nameResponse.data['status'] == 'success') {
          userName = nameResponse.data['data']['name'] ?? 'Guest';
        } else {
          return ProfileResult(
            success: false,
            message: 'Failed to fetch username',
          );
        }
      } catch (e) {
        print('Error fetching username: $e');
        return ProfileResult(
          success: false,
          message: 'Failed to fetch username: $e',
        );
      }

      // Step 2: Get Email
      try {
        final emailResponse = await _apiClient.get('/api/v1/users/profile/email');
        print('Email response status: ${emailResponse.statusCode}');
        print('Email response data: ${emailResponse.data}');

        if (emailResponse.statusCode == 200 && emailResponse.data['status'] == 'success') {
          userEmail = emailResponse.data['data']['email'] ?? '';
        } else {
          return ProfileResult(
            success: false,
            message: 'Failed to fetch email',
          );
        }
      } catch (e) {
        print('Error fetching email: $e');
        return ProfileResult(
          success: false,
          message: 'Failed to fetch email: $e',
        );
      }

      // Step 3: Get Photo
      try {
        final photoResponse = await _apiClient.get('/api/v1/users/profile/photo');
        print('Photo response status: ${photoResponse.statusCode}');
        print('Photo response data: ${photoResponse.data}');

        if (photoResponse.statusCode == 200 && photoResponse.data['status'] == 'success') {
          userPhoto = photoResponse.data['data']['photo'];
        }
        // Photo is optional, so we don't fail if it's not available
      } catch (e) {
        print('Error fetching photo (continuing anyway): $e');
        // Continue without photo
      }

      // Get user ID from storage (should be saved during login)
      userId = await _storage.getUserId();

      // Create User object with all collected data
      final user = User(
        id: userId ?? '', // Use stored ID or empty string
        email: userEmail,
        name: userName,
        profileImage: userPhoto,
      );

      // Save updated user data to local storage
      await _storage.saveUserData(
        id: userId ?? '',
        email: userEmail,
        name: userName,
        profileImage: userPhoto,
      );

      print('ProfileService: Profile loaded successfully');
      return ProfileResult(
        success: true,
        message: 'Profile loaded successfully',
        user: user,
      );

    } on DioException catch (e) {
      print('DioException in getProfile: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');

      if (e.response != null) {
        final statusCode = e.response!.statusCode;

        if (statusCode == 401) {
          return ProfileResult(
            success: false,
            message: 'Unauthorized. Please login again.',
          );
        } else if (statusCode == 404) {
          return ProfileResult(
            success: false,
            message: 'Profile not found',
          );
        }
      }

      return ProfileResult(
        success: false,
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      print('Unknown error in getProfile: $e');
      return ProfileResult(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
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
  Future<ProfileResult> updateProfileImage(String photoUrl) async {
    try {
      print('ProfileService: Updating profile photo to: $photoUrl');

      // Send PATCH request with photo URL
      final response = await _apiClient.patch(
        '/api/v1/users/profile/updateuserphoto',
        data: {
          'photo': photoUrl,
        },
      );

      print('Update photo response status: ${response.statusCode}');
      print('Update photo response data: ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        // Save the photo URL to local storage
        await _storage.saveProfileImage(photoUrl);

        // Fetch the complete profile to get updated user data
        final profileResult = await getProfile();
        
        if (profileResult.success && profileResult.user != null) {
          return ProfileResult(
            success: true,
            message: 'Profile image updated successfully',
            user: profileResult.user,
          );
        } else {
          // Even if fetching fails, the update was successful
          return ProfileResult(
            success: true,
            message: 'Profile image updated successfully',
          );
        }
      } else {
        return ProfileResult(
          success: false,
          message: response.data['message'] ?? 'Failed to update image',
        );
      }
    } on DioException catch (e) {
      print('DioException in updateProfileImage: ${e.type}');
      print('DioException response: ${e.response?.data}');

      return ProfileResult(
        success: false,
        message: 'Failed to upload image: ${e.message}',
      );
    } catch (e) {
      print('Unknown error in updateProfileImage: $e');
      return ProfileResult(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  /// Helper method to get just the username
  Future<String?> getUsername() async {
    try {
      final response = await _apiClient.get('/api/v1/users/profile/username');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data['data']['name'];
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
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data['data']['email'];
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
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data['data']['photo'];
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
