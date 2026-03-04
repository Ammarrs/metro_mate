class ApiConfig {
  static const String baseUrl = 'https://metrodb-production.up.railway.app';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String loginEndpoint = '/api/v1/users/login';
}
