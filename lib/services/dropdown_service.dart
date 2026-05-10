import 'package:dio/dio.dart';
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
  );

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