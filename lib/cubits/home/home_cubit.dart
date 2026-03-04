import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/cubits/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(components: []));
  
  
}
