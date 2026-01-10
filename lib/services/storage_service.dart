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

  Future<String?> getUserName() async {
    await _init();
    return _prefs?.getString(_userNameKey);
  }

  Future<String?> getUserEmail() async {
    await _init();
    return _prefs?.getString(_userEmailKey);
  }

  Future<String?> getUserId() async {
    await _init();
    return _prefs?.getString(_userIdKey);
  }

  Future<Map<String, String>?> getUserData() async {
    await _init();
    final id = _prefs?.getString(_userIdKey);
    final email = _prefs?.getString(_userEmailKey);
    final name = _prefs?.getString(_userNameKey);
    
    if (id != null && email != null && name != null) {
      return {'id': id, 'email': email, 'name': name};
    }
    return null;
  }

  Future<void> clearAll() async {
    await _init();
    await _prefs?.clear();
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
