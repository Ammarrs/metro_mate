import 'package:flutter_bloc/flutter_bloc.dart';


class Navigate_Cubit extends Cubit<int>{
  Navigate_Cubit(): super(0);


    void ChangeIndex(int Index){
      emit(Index);

    }



}