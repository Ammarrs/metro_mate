import 'package:dio/dio.dart';
import 'package:second/models/auth_result.dart';

import 'package:second/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  static const String _loginEndpoint = ApiConfig.loginEndpoint;

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? fcm_token = prefs.getString("fcm_token");
    try {
      if (!_isValidEmail(email)) {
        return AuthResult(success: false, messageKey: 'invalid_email');
      }
      if (password.isEmpty || password.length < 6) {
        return AuthResult(
          success: false,
          messageKey: 'password_short',
        );
      }

      print('Attempting login with email: $email');

      final response = await _apiClient.post(
        _loginEndpoint,
        data: {
          'email': email,
          'password': password,
          'fcmToken': fcm_token,
        },
      );

      print("FCM: ${fcm_token}");
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Save token if exists
        if (data['token'] != null) {
          await _storage.saveToken(data['token']);
          print('Token saved: ${data['token']}');
        }

        // Parse user data
        final userJson = data['data']['user'];
        final user = User.fromJson(userJson);

        // Save user data
        await _storage.saveUserData(
          id: user.id,
          email: user.email,
          name: user.name,
        );

        return AuthResult(
          success: true,
          messageKey: 'login_success',
          user: user,
        );
      } else {
        return AuthResult(
          success: false,
          // message: response.data['message'] ?? 'Login failed',
          messageKey: "login_failed",
        );
      }
    } on DioException catch (e) {
      print('DioException caught: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');

      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final data = e.response!.data;

        if (statusCode == 401) {
          // Handle 401 Unauthorized
          String errorMessage = 'invalid_credentials';

          if (data is Map && data['message'] != null) {
            errorMessage = data['message'];
          } else if (data is String) {
            errorMessage = data;
          }

          return AuthResult(success: false, messageKey: errorMessage);
        } else if (statusCode == 400) {
          // Handle 400 Bad Request
          String errorMessage = 'invalid_request';

          if (data is Map && data['message'] != null) {
            errorMessage = data['message'];
          }

          return AuthResult(success: false, messageKey: errorMessage);
        } else {
          return AuthResult(
            success: false,
            // message: 'Server error: ${statusCode}',
            messageKey: "server_error",
          );
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        return AuthResult(
          success: false,
          messageKey: 'connection_timeout',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        return AuthResult(
          success: false,
          messageKey: 'connection_error',
        );
      } else {
        return AuthResult(
          success: false,
          // message: 'Network error: ${e.message}',
          messageKey: "network_error",
        );
      }
    } catch (e) {
      print('Unknown error: $e');
      return AuthResult(
        success: false,
        // message: 'An unexpected error occurred: ${e.toString()}',
        messageKey: "unexpected_error",
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
