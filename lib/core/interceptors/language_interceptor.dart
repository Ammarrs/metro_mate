// lib/core/network/interceptors/language_interceptor.dart

import 'dart:ui';
import 'package:dio/dio.dart';

class LanguageInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final languageCode = PlatformDispatcher.instance.locale.languageCode; // 'ar' or 'en'
    
    options.headers['Accept-Language'] = languageCode;
    
    super.onRequest(options, handler);
  }
}