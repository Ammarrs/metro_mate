import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

/// SharedPreferences keys used across the app
class AppPrefKeys {
  static const String token = 'Token';
  static const String subscriptionId = 'subscription_id';
}

/// Handles POST /api/v1/subscriptions/create (multipart/form-data).
/// Reads Bearer token from SharedPreferences key "Token".
/// Stores the returned subscription _id in SharedPreferences key "subscription_id".
class VerifyIdentityRepository {
  late final Dio _dio;

  VerifyIdentityRepository({Dio? dio}) {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: ApiConfig.connectTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
            headers: ApiConfig.headers,
          ),
        );

    _dio.interceptors.addAll([
      LogInterceptor(requestBody: false, responseBody: true),
      _AuthInterceptor(),       // attaches Bearer token from SharedPreferences
    ]);
  }

  /// POST /api/v1/subscriptions/create
  ///
  /// Required fields (multipart/form-data):
  ///   category, duration, zones, office, start_station, end_station,
  ///   nationalId_front, nationalId_back
  ///
  /// Conditional:
  ///   universityId  — when category == "students"
  ///   militaryId    — when category == "military"
  ///
  /// On success, saves the returned subscription _id to SharedPreferences.
  Future<String> createSubscription({
    required String category,
    required String duration,
    required int zones,
    required String office,
    required String startStation,
    required String endStation,
    required File nationalIdFront,
    required File nationalIdBack,
    File? universityId,
    File? militaryId,
  }) async {
    try {
      final fields = <String, dynamic>{
        'category': category,
        'duration': duration,
        'zones': zones.toString(),
        'office': office,
        'start_station': startStation,
        'end_station': endStation,
        'nationalId_front': await MultipartFile.fromFile(
          nationalIdFront.path,
          filename: _fileName(nationalIdFront.path),
        ),
        'nationalId_back': await MultipartFile.fromFile(
          nationalIdBack.path,
          filename: _fileName(nationalIdBack.path),
        ),
      };

      if (universityId != null) {
        fields['universityId'] = await MultipartFile.fromFile(
          universityId.path,
          filename: _fileName(universityId.path),
        );
      }
      if (militaryId != null) {
        fields['militaryId'] = await MultipartFile.fromFile(
          militaryId.path,
          filename: _fileName(militaryId.path),
        );
      }

      final response = await _dio.post(
        '/api/v1/subscriptions/create',
        data: FormData.fromMap(fields),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract _id from response and persist it
        final data = response.data?['data'] as Map<String, dynamic>?;
        final subscriptionId = data?['_id'] as String? ?? '';

        if (subscriptionId.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(AppPrefKeys.subscriptionId, subscriptionId);
        }

        return subscriptionId;
      }

      final msg = response.data?['message'] as String?;
      throw Exception(msg ?? 'Subscription creation failed.');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _fileName(String path) => path.split('/').last;

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timed out. Please check your internet.');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final msg = e.response?.data?['message'] as String?;
        if (code == 401) return Exception('Session expired. Please log in again.');
        if (code == 413) return Exception('File too large. Maximum size is 5 MB.');
        if (code == 422) return Exception(msg ?? 'Invalid data. Please check your inputs.');
        return Exception(msg ?? 'Server error ($code). Please try again.');
      case DioExceptionType.cancel:
        return Exception('Request cancelled.');
      default:
        return Exception('Network error. Please check your connection.');
    }
  }
}

/// Reads the Bearer token from SharedPreferences key "Token"
/// and attaches it to every request automatically.
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppPrefKeys.token) ?? '';
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // If SharedPreferences fails, proceed without token
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expired — caller should redirect to login
    }
    handler.next(err);
  }
}