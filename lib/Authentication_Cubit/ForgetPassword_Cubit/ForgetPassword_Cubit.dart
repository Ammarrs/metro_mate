
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ForgetPassword_State.dart';


class ForgetPasswordCubit extends Cubit<ForgetPassword_State>{
  ForgetPasswordCubit():super(ForgetPasswordIntial());
  String Email='';
  String password = '';
  String confirmPassword = '';
  String Otp="";
  bool passwordVisble=false;
  bool conPasswordVisable=false;

  void ChangeEmail(String e){
    this.Email=e;
  }

  void ChangePassword(String e){
    this.password=e;
  }
  void ChangeConfirmPassword(String e){
    this.confirmPassword=e;
  }
  void PasswordVisable(){
    passwordVisble=!(passwordVisble);
    emit(PasswordVisibility(isVisible: passwordVisble));
  }
  void ConPasswordVisable(){
    conPasswordVisable=!(conPasswordVisable);
    emit(ConfirmPasswordVisibility(isVisible: conPasswordVisable));
  }
  void ChangOtp(String e){
    this.Otp=e;
  }


  String?ValidateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return " Enter Your Email ";
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




  SendCode()async{

    try{
      emit(ForgetPasswordLoding());
   final response=await Dio().post('https://metrodb-production.up.railway.app/api/v1/users/forgotpassword',data: {
     "email": Email
    },
       options: Options(
       validateStatus: (status) => true,
    ),
    );
   responseToken =response.data["data"]["resetToken"];
Status=response.statusCode as int  ;


    print("Status: ${Status}");
    print("Token Code: ${responseToken}");
      emit(ForgetPasswordSucsees());

  } catch (e) {
      emit(ForgetPasswordError(Error: e.toString()));
  print("Dio Error: $e");
  }

}



  ResetPassword()async{
    try{
      emit(ForgetPasswordLoding());

      final response=await Dio().patch('https://metrodb-production.up.railway.app/api/v1/users/resetpassword/$responseToken',data: {
        "password": password,
        "confirm_password": confirmPassword,
        "otp": Otp,
      },
        options: Options(
          validateStatus: (status) => true,
        ),
      );



      print("Status: ${response.statusCode}");
      print("Data: ${response.data}");
      emit(ForgetPasswordSucsees());
    } catch (e) {
      emit(ForgetPasswordError(Error: e.toString()));
      print("Dio Error: $e");
    }

  }



}