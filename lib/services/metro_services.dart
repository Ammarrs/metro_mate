import 'package:dio/dio.dart';
import '../models/metro_staton_model.dart';
import '../config/api_config.dart';

class MetroService {
  final Dio _dio;

  MetroService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = ApiConfig.connectTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.options.headers = ApiConfig.headers;
  }

  Future<List<MetroStationModel>> getAllMetroStations() async {
    try {
      final response = await _dio.get(ApiConfig.allStationsEndpoint);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        List<dynamic> stationsJson;
        if (data is Map && data.containsKey('data')) {
          stationsJson = data['data'] as List;
        } else if (data is List) {
          stationsJson = data;
        } else {
          throw Exception('Unexpected response format');
        }

        return stationsJson
            .map((json) => MetroStationModel.fromAllStationsJson(
                json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load stations. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw Exception('Error fetching all metro stations: $e');
    }
  }

  Future<MetroStationModel> getNearestMetroStation({
    required double userLatitude,
    required double userLongitude,
  }) async {
    try {
      final endpoint =
          '${ApiConfig.nearestStationBaseEndpoint}/$userLatitude/$userLongitude';

      final response = await _dio.get(endpoint);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data is Map &&
            data.containsKey('data') &&
            data['data'].containsKey('nearestStation')) {
          final stationJson =
              data['data']['nearestStation'] as Map<String, dynamic>;
          return MetroStationModel.fromNearestStationJson(stationJson);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
            'Failed to load nearest station. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      throw Exception('Error fetching nearest metro station: $e');
    }
  }

  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('Connection timeout. Please check your internet connection.');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Server is taking too long to respond.');
    } else if (e.response != null) {
      throw Exception('Server error: ${e.response?.statusCode}');
    } else {
      throw Exception('Network error: ${e.message}');
    }
  }
}