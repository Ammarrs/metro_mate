import 'package:dio/dio.dart';

class RoutingService {
  final Dio _dio;

  RoutingService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.connectTimeout = Duration(seconds: 10);
    _dio.options.receiveTimeout = Duration(seconds: 10);
  }

  Future<Map<String, dynamic>> getWalkingRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      final url = 'https://router.project-osrm.org/route/v1/foot/$startLng,$startLat;$endLng,$endLat?overview=false';
      
      print('🗺️ Fetching real walking route from OSRM...');
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        
        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final distanceInMeters = route['distance'] as num;
          final durationInSeconds = route['duration'] as num;
          
          final distanceInKm = distanceInMeters / 1000;
          final walkingTimeInMinutes = (durationInSeconds / 60).ceil();
          
          print('✅ Real walking route: ${distanceInKm.toStringAsFixed(2)} km, $walkingTimeInMinutes min');
          
          return {
            'distance_km': distanceInKm,
            'walking_time_minutes': walkingTimeInMinutes,
            'success': true,
          };
        } else {
          throw Exception('No route found');
        }
      } else {
        throw Exception('Failed to get route: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ OSRM routing failed: $e - falling back to estimate');
      return {'success': false, 'error': e.toString()};
    }
  }
}