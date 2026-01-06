
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ChangePassword_State.dart';




class ChangePasswordCubit extends Cubit<ChangePassword_State>{
  ChangePasswordCubit():super(ChangePasswordIntial());
  String OldPassword='';
  String password = '';
  String confirmPassword = '';

  bool oldPasswordVisable=false;
  bool passwordVisble=false;
  bool conPasswordVisable=false;


void ChangeOldPassword(String e){
  this.OldPassword=e;
}
  void ChangePassword(String e){
    this.password=e;
  }
  void ChangeConfirmPassword(String e){
    this.confirmPassword=e;
  }
  void OldPasswordVisable(){
oldPasswordVisable=!(oldPasswordVisable);
  emit(OldPasswordVisibility(isVisible: oldPasswordVisable));
  }
  void PasswordVisable(){
    passwordVisble=!(passwordVisble);
    emit(PasswordVisibility(isVisible: passwordVisble));
  }
  void ConPasswordVisable(){
    conPasswordVisable=!(conPasswordVisable);
    emit(ConfirmPasswordVisibility(isVisible: conPasswordVisable));
  }

  String? ValidateOldPassword(String?Password1){
    if(Password1==null||Password1.isEmpty){
      return"Enter Your Password ";
    }
    String pattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(OldPassword)) {
      return "Password must be at least 8 characters, include uppercase, lowercase, number and symbol";
    }
    return null;
  }


  String? ValidatePassword(String?Password1){
    if(Password1==null||Password1.isEmpty){
      return"Enter Your Password ";
    }
    String pattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(password)) {
      return "Password must be at least 8 characters, include uppercase, lowercase, number and symbol";
    }
    return null;
  }


  String? ValidateConfimPassword(String?ConPassword) {
    if (ConPassword == null || ConPassword.isEmpty) {
      return "Enter Your Password ";
    }
    else if (ConPassword!=password) {
      return "The Password Dosn't Match";
    }
    return null;
  }



  String responseToken="";
  int Status=0;
  /**/
ChangeNewPassword()async{

  try{
    SharedPreferences shard = await SharedPreferences.getInstance();
    String? token = shard.getString('Token');

    emit(ChangePasswordLoding());
    final response=await Dio().patch('https://metrodb-production.up.railway.app/api/v1/users/changepassword',data: {
      "currentpassword": OldPassword,
      "password": password,
      "confirm_password": confirmPassword,
    },
      options: Options(
        validateStatus: (status) => true,
        headers: {
          "Authorization":  "Bearer $token",

        },

      ),
    );

    Status=response.statusCode as int  ;

    print("Status: ${Status}");
    print("Token= $token");

    emit(ChangePasswordSucsees());

  } catch (e) {
    emit(ChangePasswordError(Error: e.toString()));
    print("Dio Error: $e");
  }

}




}