import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:metro_mate/config/api_config.dart';
import 'package:metro_mate/services/storage_service.dart';

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    _setupBaseOptions();
    _setupInterceptors();
  }

  void _setupBaseOptions() {
    // Use proxy for web to avoid CORS issues
    String baseUrl = ApiConfig.baseUrl;
    
    // For web platform, use a CORS proxy (only for development)
    if (kIsWeb) {
      baseUrl = 'https://corsproxy.io/?${Uri.encodeComponent(ApiConfig.baseUrl)}';
    }
    
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService().getToken();
          if(token != null && token.isNotEmpty){
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          print('DioError: ${error.type}');
          print('DioError Message: ${error.message}');
          print('DioError Response: ${error.response}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } catch (e) {
      print('GET Error: $e');
      throw Exception(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      print('POST Error: $e');
      throw Exception(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      print('PUT Error: $e');
      throw Exception(e);
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    try {
      return await _dio.delete(path, data: data);
    } catch (e) {
      print('DELETE Error: $e');
      throw Exception(e);
    }
  }
}