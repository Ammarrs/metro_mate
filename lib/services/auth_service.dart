import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:metro_mate/config/api_config.dart';
import 'package:metro_mate/models/user_model.dart';
import 'package:metro_mate/services/api_client.dart';
import 'package:metro_mate/services/storage_service.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  static const String _loginEndpoint = ApiConfig.loginEndpoint;

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (!_isValidEmail(email)) {
        return AuthResult(success: false, message: 'Invalid Email');
      }
      if (password.isEmpty || password.length < 6) {
        return AuthResult(
          success: false,
          message: 'Password must be at least 6 characters',
        );
      }

      print('Attempting login with email: $email');
      
      final response = await _apiClient.post(
        _loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

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
          message: 'Login Successful',
          user: user,
        );
      } else {
        return AuthResult(
          success: false,
          message: response.data['message'] ?? 'Login failed',
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
          String errorMessage = 'Invalid email or password';
          
          if (data is Map && data['message'] != null) {
            errorMessage = data['message'];
          } else if (data is String) {
            errorMessage = data;
          }
          
          return AuthResult(success: false, message: errorMessage);
        } else if (statusCode == 400) {
          // Handle 400 Bad Request
          String errorMessage = 'Invalid request';
          
          if (data is Map && data['message'] != null) {
            errorMessage = data['message'];
          }
          
          return AuthResult(success: false, message: errorMessage);
        } else {
          return AuthResult(
            success: false,
            message: 'Server error: ${statusCode}',
          );
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        return AuthResult(
          success: false,
          message: 'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        return AuthResult(
          success: false,
          message: 'Connection error. Please check your internet connection.',
        );
      } else {
        return AuthResult(
          success: false,
          message: 'Network error: ${e.message}',
        );
      }
    } catch (e) {
      print('Unknown error: $e');
      return AuthResult(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}