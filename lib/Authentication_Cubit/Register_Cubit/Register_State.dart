

import 'dart:io';

abstract class Register_State {}

class RegisterInitial extends Register_State {}
class RegisterLoading extends Register_State {}
class RegisterSucsess extends Register_State {}
class RegisterError extends Register_State {
  final String Error;
  RegisterError({required this.Error});

}

class RegisterLoadingOTP extends Register_State {}
class RegisterSucsessOTP extends Register_State {}
class RegisterErrorOTP extends Register_State {
  final String Error;
  RegisterErrorOTP({required this.Error});

}


class PasswordVisibility extends Register_State {
  final bool isVisible;
  PasswordVisibility({required this.isVisible});
}

class ConfirmPasswordVisibility extends Register_State {
  final bool isVisible;
  ConfirmPasswordVisibility({required this.isVisible});
}

class RegisterGender extends Register_State {
  final String gender;
  RegisterGender({required this.gender});
}


class RegisterPickImage extends Register_State {
  final File image;
  RegisterPickImage({required this.image});
}

class ButtonState extends Register_State{
  final bool Enable;
  final int time ;
  ButtonState({
    required this.Enable,
    required this.time
  });
}

