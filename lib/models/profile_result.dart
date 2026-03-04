import 'package:second/models/user_model.dart';

class ProfileResult {
  final bool success;
  final String message;
  final User? user;

  ProfileResult({
    required this.success,
    required this.message,
    this.user,
  });
}