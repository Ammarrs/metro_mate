class ApiConfig {
  static const String baseUrl = 'https://metrodb-production.up.railway.app';
  static const Duration connectTimeout = Duration(seconds: 30);
  // static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String loginEndpoint = '/api/v1/users/login';

  static const String allStationsEndpoint = '/api/v1/trips/station';

  static const String nearestStationBaseEndpoint = '/api/v1/neareststation';
  static const String userTripHistoryEndpoint = '/api/v1/trips/usertriphistory';


  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': '*/*',
  };

  static Map<String, String> getAuthHeaders(String token) {
    return {
      ...headers,
      'Authorization': 'Bearer $token',
    };
  }
}
