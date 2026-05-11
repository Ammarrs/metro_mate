import 'package:equatable/equatable.dart';
import '../../models/crowdedness_level.dart';
import '../../models/metro_staton_model.dart';

enum MetroMessageKey {
  gettingLocation,
  findingNearestMetro,
  calculatingRoute,
  checkingCrowdedness,
  failedToLoadStation,
  stationCoordsUnavailable,
  locationDisabled,
  locationDenied,
  locationPermanentlyDenied,
}

abstract class NearestMetroState extends Equatable {
  const NearestMetroState();

  @override
  List<Object?> get props => [];
}

class NearestMetroInitial extends NearestMetroState {
  const NearestMetroInitial();
}

class NearestMetroLoading extends NearestMetroState {
  final MetroMessageKey messageKey;
  const NearestMetroLoading({required this.messageKey});

  @override
  List<Object?> get props => [messageKey];
}

class NearestMetroLoaded extends NearestMetroState {
  final MetroStationModel nearestStation;
  final double            userLatitude;
  final double            userLongitude;
  final CrowdednessLevel  crowdednessLevel;

  const NearestMetroLoaded({
    required this.nearestStation,
    required this.userLatitude,
    required this.userLongitude,
    required this.crowdednessLevel,
  });

  @override
  List<Object?> get props => [
    nearestStation,
    userLatitude,
    userLongitude,
    crowdednessLevel,
  ];
}

class NearestMetroError extends NearestMetroState {
  final MetroMessageKey messageKey;
  final String?         details;

  const NearestMetroError({required this.messageKey, this.details});

  @override
  List<Object?> get props => [messageKey, details];
}

class NearestMetroPermissionDenied extends NearestMetroState {
  final MetroMessageKey messageKey;
  final bool            isPermanentlyDenied;

  const NearestMetroPermissionDenied({
    required this.messageKey,
    this.isPermanentlyDenied = false,
  });

  @override
  List<Object?> get props => [messageKey, isPermanentlyDenied];
}

class NearestMetroLocationDisabled extends NearestMetroState {
  const NearestMetroLocationDisabled();
}