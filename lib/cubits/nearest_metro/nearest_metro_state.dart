import 'package:equatable/equatable.dart';
import '../../models/metro_staton_model.dart';

abstract class NearestMetroState extends Equatable {
  const NearestMetroState();

  @override
  List<Object?> get props => [];
}

class NearestMetroInitial extends NearestMetroState {
  const NearestMetroInitial();
}

class NearestMetroLoading extends NearestMetroState {
  final String? message;
  const NearestMetroLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class NearestMetroLoaded extends NearestMetroState {
  final MetroStationModel nearestStation;
  final double userLatitude;
  final double userLongitude;

  const NearestMetroLoaded({
    required this.nearestStation,
    required this.userLatitude,
    required this.userLongitude,
  });

  @override
  List<Object?> get props => [nearestStation, userLatitude, userLongitude];
}

class NearestMetroError extends NearestMetroState {
  final String message;
  final String? details;

  const NearestMetroError({required this.message, this.details});

  @override
  List<Object?> get props => [message, details];
}

class NearestMetroPermissionDenied extends NearestMetroState {
  final String message;
  final bool isPermanentlyDenied;

  const NearestMetroPermissionDenied({
    required this.message,
    this.isPermanentlyDenied = false,
  });

  @override
  List<Object?> get props => [message, isPermanentlyDenied];
}

class NearestMetroLocationDisabled extends NearestMetroState {
  final String message;

  const NearestMetroLocationDisabled({
    this.message = 'Location services are disabled. Please enable GPS.',
  });

  @override
  List<Object?> get props => [message];
}