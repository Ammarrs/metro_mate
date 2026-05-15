import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class StationItem {
  final String id;
  final String name;
  final int lineNumber;

  const StationItem({
    required this.id,
    required this.name,
    required this.lineNumber,
  });
}

class OfficeItem {
  final String name;
  final bool offersQuarterly;
  final bool offersYearly;

  const OfficeItem({
    required this.name,
    required this.offersQuarterly,
    required this.offersYearly,
  });
}

class DropdownService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
    ),
  )..interceptors.add(_LanguageInterceptor());

  /// GET /api/v1/trips/station
  static Future<List<StationItem>> fetchStations() async {
    final response = await _dio.get(ApiConfig.allStationsEndpoint);
    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => StationItem(
              id: e['_id'] as String,
              name: e['name'] as String,
              lineNumber: e['line_number'] as int,
            ))
        .toList();
  }

  /// GET /api/v1/subscriptions/offices
  static Future<List<OfficeItem>> fetchOffices() async {
    final response = await _dio.get('/api/v1/subscriptions/offices');
    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => OfficeItem(
              name: e['officeName'] as String,
              offersQuarterly: e['offersQuarterly'] as bool,
              offersYearly: e['offersYearly'] as bool,
            ))
        .toList();
  }
}

// ─── Language interceptor ─────────────────────────────────────────────────────
// Reads the user-selected language from SharedPreferences (key "app_language").
// Falls back to the device locale (e.g. "ar_EG" → "ar") on first launch before
// the user changes anything in Settings.
// When SettingsCubit saves a new language it is picked up automatically on the
// next request — no restart required.
class _LanguageInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(ApiConfig.languagePrefKey);
      final lang = (saved != null && saved.isNotEmpty)
          ? saved
          : Platform.localeName.split('_').first;
      options.headers['Accept-Language'] = lang;
    } catch (_) {
      // If reading fails, proceed without the header
    }
    handler.next(options);
  }
}