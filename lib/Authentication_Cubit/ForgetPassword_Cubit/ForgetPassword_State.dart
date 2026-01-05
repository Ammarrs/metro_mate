abstract class ForgetPassword_State{}
class ForgetPasswordIntial extends ForgetPassword_State{}

class  ForgetPasswordLoding extends ForgetPassword_State{}
class  ForgetPasswordSucsees extends ForgetPassword_State{}
class  ForgetPasswordError extends ForgetPassword_State{
  final String Error;
  ForgetPasswordError({required this.Error});

}
class PasswordVisibility extends ForgetPassword_State {
  final bool isVisible;
  PasswordVisibility({required this.isVisible});
}

class ConfirmPasswordVisibility extends ForgetPassword_State {
  final bool isVisible;
  ConfirmPasswordVisibility({required this.isVisible});
}
