import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class ApiConfig {
  static const String baseUrl = 'https://metrodb-production.up.railway.app';
  static const Duration connectTimeout = Duration(seconds: 30);
  // static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String loginEndpoint = '/api/v1/users/login';

  static const String allStationsEndpoint = '/api/v1/trips/station';

  static const String nearestStationBaseEndpoint = '/api/v1/neareststation';

  static const String userTripHistoryEndpoint = '/api/v1/trips/usertriphistory';
  
  static const String subscriptionPlansEndpoint = '/api/v1/subscriptions/plans';

  static const String aiChatEndpoint = '/api/v1/chatbot';
  static const String aiChatHistoryEndpoint = '/api/v1/chatbot/history';

  static const String crowdingEndpoint = '/api/v1/neareststation/crowding';


  // ─── SharedPreferences key for the user-selected language ──────────────────
  // SettingsCubit / AppPreferencesCard must persist the BCP-47 tag here when
  // the user changes the app language, e.g.:
  //   prefs.setString(ApiConfig.languagePrefKey, 'ar');
  static const String languagePrefKey = 'lang';

  // ─── Synchronous base headers (no language — use headersWithLanguage()) ────
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      };

  // ─── Full headers including Accept-Language ────────────────────────────────
  // Reads the persisted language from SharedPreferences; falls back to the
  // device locale so the first launch is already correct.
  static Future<Map<String, String>> headersWithLanguage() async {
    final lang = await getCurrentLanguage();
    return {
      ...headers,
      'Accept-Language': lang,
    };
  }

  /// Returns the active BCP-47 language tag, e.g. "ar" or "en".
  /// Priority: user preference in SharedPreferences → device locale.
  static Future<String> getCurrentLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(languagePrefKey);
      if (saved != null && saved.isNotEmpty) return saved;
    } catch (_) {}
    // e.g. "ar_EG" → "ar"
    return Platform.localeName.split('_').first;
  }

  static Map<String, String> getAuthHeaders(String token) {
    return {
      ...headers,
      'Authorization': 'Bearer $token',
    };
  }

}
