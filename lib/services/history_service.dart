import '../config/api_config.dart';
import '../models/trip_record.dart';
import 'api_client.dart';

class HistoryService {
  final ApiClient _apiClient = ApiClient();

  Future<List<TripRecord>> getUserTripHistory() async {
    try {
      print('HistoryService: Fetching trip history...');
      final response = await _apiClient.get(ApiConfig.userTripHistoryEndpoint);

      print('HistoryService: status = ${response.statusCode}');
      print('HistoryService: data = ${response.data}');

      if (response.statusCode == 200) {
        final body = response.data;
        if (body is! Map<String, dynamic>) {
          print('HistoryService: unexpected body type');
          return [];
        }

        final List<dynamic> raw = body['data'] ?? [];
        return raw
            .whereType<Map<String, dynamic>>()
            .map((json) => TripRecord.fromJson(json))
            .toList();
      } else {
        print('HistoryService: non-200 status ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('HistoryService error: $e');
      return [];
    }
  }
}