import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
final AuthService _authService;

LoginCubit(this._authService) : super(LoginInitial());

Future<void> signIn({
required String email,
required String password,
}) async {
emit(LoginLoading());


try {
  final result = await _authService.signIn(
    email: email,
    password: password,
  );

  if (result.success && result.user != null) {
    emit(LoginSuccess(result.user!));
  } else {
    emit(
      LoginFailure(
        messageKey: result.messageKey ?? 'unknown_error',
      ),
    );
  }
} catch (e) {
  emit(
    const LoginFailure(
      messageKey: 'unexpected_error',
    ),
  );
}


}

void reset() {
emit(LoginInitial());
}
}
