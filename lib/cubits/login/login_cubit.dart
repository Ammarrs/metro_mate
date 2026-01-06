import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService;

  LoginCubit(this._authService) : super(LoginInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(LoginLoading());
    print("Login Started");

    try {
      final result = await _authService.signIn(
        email: email,
        password: password,
      );
      print("Result: ${result.success}");

      if (result.success && result.user != null) {
        print("Emitting Success");
        emit(LoginSuccess(result.user!));
      } else {
        print("Emitting LoginFailure");
        emit(LoginFailure(error: result.message));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  void reset() {
    emit(LoginInitial());
  }
}
