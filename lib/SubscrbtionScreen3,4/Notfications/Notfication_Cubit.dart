import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<int> {
  NotificationCubit() : super(0);

  void increase() => emit(state + 1);

  void reset() => emit(0);
}
