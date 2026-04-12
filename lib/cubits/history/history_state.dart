import '../../models/trip_record.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<TripRecord> trips;
  HistoryLoaded(this.trips);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}