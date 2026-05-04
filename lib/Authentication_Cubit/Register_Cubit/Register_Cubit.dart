import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Register_Cubit/Register_State.dart';

class RegisterCubit extends Cubit<Register_State> {
  RegisterCubit() : super(RegisterInitial());
  String token = "";
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String phone = '';
  String gender = '';
  String Otp = '';
  bool passwordVisable = false;
  bool ConfirmPasswordVisable = false;
  int _resendTime = 30;
  Timer? _timer;

  File? profileImage;
  String? base64Image;
  String DefaultImage =
      'https://t4.ftcdn.net/jpg/09/64/89/19/360_F_964891988_aeRrD7Ee7IhmKQhYkCrkrfE6UHtILfPp.jpg';

  final ImagePicker picker = ImagePicker();

  void startResendTimer() {
    int time = _resendTime;
    emit(ButtonState(enable: false, time: time));

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      time--;
      if (time <= 0) {
        timer.cancel();
        emit(ButtonState(enable: true, time: 0));
      } else {
        emit(ButtonState(enable: false, time: time));
      }
    });
  }

  void resendOtpWithTimer() async {
    await RsendOtp();

    startResendTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void ChangeName(String Name) {
    this.name = Name;
  }

  void ChangeEmail(String Email) {
    this.email = Email;
  }

  void ChangePassword(String Password) {
    this.password = Password;
  }

  void ChangeConfimPassword(String ConPassword) {
    this.confirmPassword = ConPassword;
  }

  void ChangePhone(String Phone) {
    this.phone = Phone;
  }

  void ChangeGender(String Gender) {
    this.gender = Gender;
    emit(RegisterGender(gender: Gender));
  }

  void PasswordVisable() {
    passwordVisable = !(passwordVisable);
    emit(PasswordVisibility(isVisible: passwordVisable));
  }

  void ConPasswordVisable() {
    ConfirmPasswordVisable = !(ConfirmPasswordVisable);
    emit(ConfirmPasswordVisibility(isVisible: ConfirmPasswordVisable));
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      await convertToBase64();
      emit(RegisterPickImage(image: profileImage!));
    }
  }

  Future<void> convertToBase64() async {
    if (profileImage == null) return;

    final bytes = await profileImage!.readAsBytes();
    base64Image = base64Encode(bytes);
  }

  void ChangOtp(String e) {
    this.Otp = e;
  }

  String? ValidateName(String? name) {
    if (name == null || name.isEmpty) {
      return "enterYourName";
    }
    return null;
  }

  String? ValidateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "enterYourEmail";
    } else if (!(email.contains('@')) || !(email.contains('.com'))) {
      return "invalidEmail";
    }
    return null;
  }

  String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "enterPhone";
    }

    String pattern = r'^01\d{9}$';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(phone)) {
      return "invalidPhone";
    }
    return null;
  }

  String? ValidatePassword(String? Password1) {
    if (Password1 == null || Password1.isEmpty) {
      return "enterYourPassword";
    }
    String pattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(password)) {
      return "passwordInvalid";
    }
    return null;
  }

  String? ValidateConfimPassword(String? ConPassword) {
    if (ConPassword == null || ConPassword.isEmpty) {
      return "enterYourPassword";
    } else if (ConPassword != password) {
      return "passwordNotMatch";
    }
    return null;
  }

  bool CheckGender() {
    return gender.isNotEmpty;
  }

  Future<void> setToken() async {
    SharedPreferences shard = await SharedPreferences.getInstance();
    await shard.setString('Token', token);
  }

  Future<void> SignUp() async {
    try {
      emit(RegisterLoading());
      final response = await Dio().post(
        'https://metrodb-production.up.railway.app/api/v1/users/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "confirm_password": confirmPassword,
          "phone": phone,
          "gender": gender,
          "photo": base64Image ?? DefaultImage
        },
        options: Options(
          validateStatus: (status) => true,
        ),
      );
      if (response.data["token"] != null) {
        token = response.data["token"];

        await setToken();
        print("Token: $token");
      } else {
        emit(RegisterError(Error: "Token not found in response"));
      }
      emit(RegisterSucsess());

      print("Status: ${response.statusCode}");
      print("Data: ${response.data}");
    } catch (e) {
      emit(RegisterError(Error: e.toString()));
      print("Dio Error: $e");
    }
  }

  RsendOtp() async {
    try {
      emit(RegisterLoadingOTP());
      final response = await Dio().post(
        'https://metrodb-production.up.railway.app/api/v1/users/resendOTP',
        data: {"email": email},
        options: Options(validateStatus: (_) => true),
      );
      print("Status: ${response.statusCode}");
      print("Data: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(RegisterSucsessOTP());
      } else {
        emit(RegisterErrorOTP(Error: "Invalid OTP"));
      }
    } catch (e) {
      emit(RegisterErrorOTP(Error: e.toString()));
      print("Dio Error: $e");
    }
  }

  VerfiyOtp() async {
    try {
      emit(RegisterLoading());
      final response = await Dio().post(
          'https://metrodb-production.up.railway.app/api/v1/users/verifyOTP',
          data: {"otp": Otp, "email": email});
      await setToken();
      print("token= $token");
      print("Status: ${response.statusCode}");
      print("Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(RegisterSucsess());
      } else {
        emit(RegisterError(Error: "Invalid OTP"));
      }
    } catch (e) {
      emit(RegisterError(Error: e.toString()));
      print("Dio Error: $e");
    }
  }
}
