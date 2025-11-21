import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }


  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  Future<void> saveToken(String token) async {
    await _init();
    await _prefs!.setString('auth_token', token);
  }

  String? getToken() {
    return _prefs?.getString('auth_token');
  }

  bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearToken() async {
    await _init();
    await _prefs?.remove('auth_token');
  }

  Future<void> saveUserData({
  required String id,
  required String email,
  required String name,
}) async {
  await _init();
  _prefs!
    ..setString(_userIdKey, id)
    ..setString(_userEmailKey, email)
    ..setString(_userNameKey, name);
}


}
