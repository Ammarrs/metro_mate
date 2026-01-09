import 'package:dio/dio.dart';
import 'package:second/services/storage_service.dart';


import '../config/api_config.dart';

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    _setupBaseOptions();
    _setupInterceptors();
  }

  void _setupBaseOptions() {
    String baseUrl = ApiConfig.baseUrl;
    
    // IMPORTANT: Only use CORS proxy if you're actually getting CORS errors
    // For now, let's try without it since it might be causing the 401
    // if (kIsWeb) {
    //   baseUrl = 'https://corsproxy.io/?${Uri.encodeComponent(ApiConfig.baseUrl)}';
    // }
    
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        // Accept all status codes so we can handle them manually
        return status != null && status < 500;
      },
    );
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          print('REQUEST DATA: ${options.data}');
          
          final token = await StorageService().getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print('Authorization header added');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          print('ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}');
          print('ERROR RESPONSE: ${error.response?.data}');
          print('ERROR TYPE: ${error.type}');
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
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);

    } catch (e) {
      print('POST Error: $e');
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      print('PUT Error: $e');
      rethrow;
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    try {
      return await _dio.delete(path, data: data);
    } catch (e) {
      print('DELETE Error: $e');
      rethrow;
    }
  }
}