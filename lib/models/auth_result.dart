import 'package:second/models/user_model.dart';

class AuthResult {
  final bool success;
  final String? messageKey;
  final User? user;

  AuthResult({required this.success, this.messageKey, this.user});
}