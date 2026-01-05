import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metro_mate/block/state_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBordingIntial());

 Future <void> SetSeen() async {
    SharedPreferences shard = await SharedPreferences.getInstance();
    await shard.setBool('seen', true);
    emit(OnBordingSeen());
  }

  Future<void> CheckSeen() async {
    SharedPreferences shard = await SharedPreferences.getInstance();
    var seen = shard.getBool('seen') ?? false;
    if (seen) {
      emit(OnBordingSeen());
    } else {
      emit(OnBordingNotSeen());
    }
  }


}
