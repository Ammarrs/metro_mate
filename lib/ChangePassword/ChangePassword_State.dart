abstract class ChangePassword_State{}
class ChangePasswordIntial extends ChangePassword_State{}

class  ChangePasswordLoding extends ChangePassword_State{}
class  ChangePasswordSucsees extends ChangePassword_State{}
class  ChangePasswordError extends ChangePassword_State{
  final String Error;
  ChangePasswordError({required this.Error});

}
class OldPasswordVisibility extends ChangePassword_State {
  final bool isVisible;
  OldPasswordVisibility({required this.isVisible});
}

class PasswordVisibility extends ChangePassword_State {
  final bool isVisible;
  PasswordVisibility({required this.isVisible});
}

class ConfirmPasswordVisibility extends ChangePassword_State {
  final bool isVisible;
  ConfirmPasswordVisibility({required this.isVisible});
}
