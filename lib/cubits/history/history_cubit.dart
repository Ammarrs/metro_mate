import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/history_service.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryService _service;

  HistoryCubit(this._service) : super(HistoryInitial());

  Future<void> loadHistory() async {
    if (isClosed) return;
    emit(HistoryLoading());
    try {
      final trips = await _service.getUserTripHistory();
      if (isClosed) return;
      emit(HistoryLoaded(trips));
    } catch (e) {
      if (isClosed) return;
      emit(HistoryError('Failed to load history: $e'));
    }
  }
}