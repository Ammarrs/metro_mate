import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/metro_staton_model.dart';
import '../../services/location_services.dart';
import '../../services/metro_services.dart';
import '../../services/routing_service.dart';
import 'nearest_metro_state.dart';

class NearestMetroCubit extends Cubit<NearestMetroState> {
  final LocationService _locationService;
  final MetroService _metroService;
  final RoutingService _routingService;

  NearestMetroCubit({
    LocationService? locationService,
    MetroService? metroService,
    RoutingService? routingService,
  })  : _locationService = locationService ?? LocationService(),
        _metroService = metroService ?? MetroService(),
        _routingService = routingService ?? RoutingService(),
        super(const NearestMetroInitial());

  Future<void> loadNearestMetro() async {
    try {
      print('🔄 Starting loadNearestMetro...');
      if (isClosed) return;
      emit(const NearestMetroLoading(message: 'Getting your location...'));

      Position userPosition;
      try {
        print('📍 Requesting user location...');
        userPosition = await _locationService.getCurrentLocation();
        print('✅ Got location: ${userPosition.latitude}, ${userPosition.longitude}');
      } on Exception catch (e) {
        print('❌ Location error: $e');
        if (isClosed) return;
        final msg = e.toString();
        if (msg.contains('disabled')) {
          emit(const NearestMetroLocationDisabled());
          return;
        } else if (msg.contains('denied')) {
          emit(NearestMetroPermissionDenied(
            message: msg,
            isPermanentlyDenied: msg.contains('permanently'),
          ));
          return;
        }
        rethrow;
      }

      if (isClosed) return;
      emit(const NearestMetroLoading(message: 'Finding nearest metro...'));

      print('🚇 Calling nearest station API...');
      final MetroStationModel nearestStation;
      try {
        nearestStation = await _metroService.getNearestMetroStation(
          userLatitude: userPosition.latitude,
          userLongitude: userPosition.longitude,
        );
        print('✅ Got nearest station: ${nearestStation.name}');
      } catch (e) {
        print('❌ API Error: $e');
        if (isClosed) return;
        emit(NearestMetroError(
          message: 'Failed to load nearest metro station',
          details: 'API Error: ${e.toString()}',
        ));
        return;
      }

      if (nearestStation.lat == null || nearestStation.lng == null) {
        print('❌ Station has no coordinates');
        if (isClosed) return;
        emit(const NearestMetroError(
          message: 'Failed to load nearest metro station',
          details: 'Station coordinates not available',
        ));
        return;
      }

      if (isClosed) return;
      emit(const NearestMetroLoading(message: 'Calculating walking route...'));

      print('🗺️ Getting real walking route...');
      final routeResult = await _routingService.getWalkingRoute(
        startLat: userPosition.latitude,
        startLng: userPosition.longitude,
        endLat: nearestStation.lat!,
        endLng: nearestStation.lng!,
      );

      double distance;
      int walkingTime;

      if (routeResult['success'] == true) {
        distance = routeResult['distance_km'];
        walkingTime = routeResult['walking_time_minutes'];
        print('✅ Using REAL route: ${distance.toStringAsFixed(2)} km, $walkingTime min');
      } else {
        print('⚠️ Routing failed, using estimate...');
        distance = _locationService.calculateDistance(
          startLatitude: userPosition.latitude,
          startLongitude: userPosition.longitude,
          endLatitude: nearestStation.lat!,
          endLongitude: nearestStation.lng!,
        );
        distance = distance * 1.3;
        walkingTime = _locationService.calculateWalkingTime(distance);
        print('📏 Using estimate: ${distance.toStringAsFixed(2)} km, $walkingTime min');
      }

      nearestStation.distanceInKm = distance;
      nearestStation.walkingTimeInMinutes = walkingTime;

      if (isClosed) return;
      print('✅ Emitting loaded state');
      emit(NearestMetroLoaded(
        nearestStation: nearestStation,
        userLatitude: userPosition.latitude,
        userLongitude: userPosition.longitude,
      ));

      print('✅ loadNearestMetro completed successfully');
    } catch (e, stackTrace) {
      print('❌ Unexpected error in loadNearestMetro: $e');
      print('Stack trace: $stackTrace');
      if (isClosed) return;
      emit(NearestMetroError(
        message: 'Failed to load nearest metro station',
        details: e.toString(),
      ));
    }
  }

  Future<void> refresh() async {
    print('🔄 Refresh button pressed');
    await loadNearestMetro();
  }

  Future<void> openLocationSettings() async =>
      await _locationService.openLocationSettings();
}