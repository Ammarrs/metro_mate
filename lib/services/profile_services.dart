import 'package:dio/dio.dart';
import 'package:second/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  // Get user profile from backend
  Future<ProfileResult> getProfile() async {
    try {
      print('Fetching user profile...');

      final response = await _apiClient.get('/api/v1/users/profile');

      print('Profile response status: ${response.statusCode}');
      print('Profile response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        final user = User.fromJson(data['data']['user']);

        // Save updated user data to storage
        await _storage.saveUserData(
          id: user.id,
          email: user.email,
          name: user.name,
          profileImage: user.profileImage,
        );

        return ProfileResult(
          success: true,
          message: 'Profile loaded successfully',
          user: user,
        );
      } else {
        return ProfileResult(
          success: false,
          message: response.data['message'] ?? 'Failed to load profile',
        );
      }
    } on DioException catch (e) {
      print('DioException: ${e.type}');
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
      print('Unknown error: $e');
      return ProfileResult(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Update profile image
  Future<ProfileResult> updateProfileImage(String imagePath) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      final String? token = _pref.getString("Token");

      print('Uploading profile image: $imagePath');

      // Create FormData for file upload
      FormData formData = FormData.fromMap({
        'profileImage': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      final response = await _apiClient.put(
        '/api/v1/users/profile/image',
        data: {formData},
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Upload response status: ${response.statusCode}');
      print('Upload response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        final user = User.fromJson(data['data']['user']);

        // Save updated profile image
        await _storage.saveProfileImage(user.profileImage ?? '');

        return ProfileResult(
          success: true,
          message: 'Profile image updated successfully',
          user: user,
        );
      } else {
        return ProfileResult(
          success: false,
          message: response.data['message'] ?? 'Failed to update image',
        );
      }
    } on DioException catch (e) {
      print('DioException: ${e.type}');
      print('DioException response: ${e.response?.data}');

      return ProfileResult(
        success: false,
        message: 'Failed to upload image: ${e.message}',
      );
    } catch (e) {
      print('Unknown error: $e');
      return ProfileResult(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }
}

// Result class for profile operations
class ProfileResult {
  final bool success;
  final String message;
  final User? user;

  ProfileResult({
    required this.success,
    required this.message,
    this.user,
  });
}
