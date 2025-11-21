import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metro_mate/config/api_config.dart';
import 'package:metro_mate/models/user_model.dart';
import 'package:metro_mate/services/api_client.dart';
import 'package:metro_mate/services/storage_service.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storage = StorageService();

  static const String _baseUrl = ApiConfig.baseUrl;
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
          message: 'Password must at least 6 characters',
        );
      }

      final response = await _apiClient.post(
        _baseUrl + _loginEndpoint,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['token'] != null) await _storage.saveToken(data['token']);
        final user = User.fromJson(data['user'] ?? data['data']);
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
    } catch (e) {
      return AuthResult(success: false, message: e.toString());
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
