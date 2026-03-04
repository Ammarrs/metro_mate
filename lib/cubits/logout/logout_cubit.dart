import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/cubits/logout/logout_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit() : super(LoginOutIntial());

  Future<void> logout() async {
    try {
      print("=== Starting Logout Process ===");
      emit(LogoutLoading());
      print("Emitted LogoutLoading state");
      
      final prefs = await SharedPreferences.getInstance();
      print("Got SharedPreferences instance");
      
      // Check if token exists before removing
      final token = prefs.getString('Token');
      print("Current token: ${token != null ? 'EXISTS' : 'NOT FOUND'}");
      
      final removed = await prefs.remove('Token');
      print("Token removed: $removed");
      
      // Verify token is removed
      final checkToken = prefs.getString('Token');
      print("Token after removal: ${checkToken ?? 'null (successfully removed)'}");

      Dio().options.headers.remove('Authorization');
      print("Removed Authorization header from Dio");

      emit(LogOutSuccessful());
      print("Emitted LogOutSuccessful state");
      print("=== Logout Process Complete ===");
    } catch (e) {
      print("ERROR during logout: $e");
      emit(LoginOutIntial()); // Go back to initial state on error
    }
  }
}