import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/metro_staton_model.dart';
import '../../services/location_services.dart';
import '../../services/metro_services.dart';
import 'nearest_metro_state.dart';

class NearestMetroCubit extends Cubit<NearestMetroState> {
  final LocationService _locationService;
  final MetroService _metroService;
  GoogleMapController? _mapController;

  NearestMetroCubit({
    LocationService? locationService,
    MetroService? metroService,
  })  : _locationService = locationService ?? LocationService(),
        _metroService = metroService ?? MetroService(),
        super(const NearestMetroInitial());

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> loadNearestMetro() async {
    try {
      emit(const NearestMetroLoading(message: 'Getting your location...'));

      Position userPosition;
      try {
        userPosition = await _locationService.getCurrentLocation();
      } on Exception catch (e) {
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

      final userLatLng = LatLng(userPosition.latitude, userPosition.longitude);

      emit(const NearestMetroLoading(message: 'Finding nearest metro...'));

      final MetroStationModel nearestStation =
          await _metroService.getNearestMetroStation(
        userLatitude: userPosition.latitude,
        userLongitude: userPosition.longitude,
      );

      final double distance = _locationService.calculateDistance(
        startLatitude: userPosition.latitude,
        startLongitude: userPosition.longitude,
        endLatitude: nearestStation.lat!,
        endLongitude: nearestStation.lng!,
      );

      final int walkingTime = _locationService.calculateWalkingTime(distance);

      nearestStation.distanceInKm = distance;
      nearestStation.walkingTimeInMinutes = walkingTime;

      final Set<Marker> markers = _createMarkers(
        userLocation: userLatLng,
        nearestStation: nearestStation,
      );

      emit(NearestMetroLoaded(
        nearestStation: nearestStation,
        userLocation: userLatLng,
        markers: markers,
      ));

      _animateCameraToFitBoth(userLatLng, nearestStation);
    } catch (e) {
      emit(NearestMetroError(
        message: 'Failed to load nearest metro station',
        details: e.toString(),
      ));
    }
  }

  Set<Marker> _createMarkers({
    required LatLng userLocation,
    required MetroStationModel nearestStation,
  }) {
    return {
      Marker(
        markerId: const MarkerId('user_location'),
        position: userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'You are here',
        ),
      ),
      Marker(
        markerId: MarkerId('metro_${nearestStation.id}'),
        position: LatLng(nearestStation.lat!, nearestStation.lng!),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: nearestStation.name,
          snippet:
              '${nearestStation.distanceInKm?.toStringAsFixed(1)} km • ${nearestStation.lineLabel}',
        ),
      ),
    };
  }

  void _animateCameraToFitBoth(
    LatLng userLocation,
    MetroStationModel nearestStation,
  ) {
    if (_mapController == null) return;

    final stationLatLng = LatLng(nearestStation.lat!, nearestStation.lng!);

    final double southLat = userLocation.latitude < stationLatLng.latitude
        ? userLocation.latitude
        : stationLatLng.latitude;
    final double northLat = userLocation.latitude > stationLatLng.latitude
        ? userLocation.latitude
        : stationLatLng.latitude;
    final double westLng = userLocation.longitude < stationLatLng.longitude
        ? userLocation.longitude
        : stationLatLng.longitude;
    final double eastLng = userLocation.longitude > stationLatLng.longitude
        ? userLocation.longitude
        : stationLatLng.longitude;

    const double padding = 0.003;
    final bounds = LatLngBounds(
      southwest: LatLng(southLat - padding, westLng - padding),
      northeast: LatLng(northLat + padding, eastLng + padding),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  Future<void> refresh() async => await loadNearestMetro();

  Future<void> openLocationSettings() async =>
      await _locationService.openLocationSettings();

  @override
  Future<void> close() {
    _mapController?.dispose();
    return super.close();
  }
}