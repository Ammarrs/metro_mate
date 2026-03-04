import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static const String _tokenKey = 'Token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _profileImageKey = 'profile_image'; // NEW

  Future<void> saveToken(String token) async {
    await _init();
    await _prefs!.setString(_tokenKey, token);
    print("token is: $token");
  }

  Future<String?> getToken() async {
    await _init();
    return _prefs?.getString(_tokenKey);
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

  // NEW: Get profile image
  Future<String?> getProfileImage() async {
    await _init();
    return _prefs?.getString(_profileImageKey);
  }

  Future<Map<String, String>?> getUserData() async {
    await _init();
    final id = _prefs?.getString(_userIdKey);
    final email = _prefs?.getString(_userEmailKey);
    final name = _prefs?.getString(_userNameKey);
    final profileImage = _prefs?.getString(_profileImageKey); // NEW
    
    if (id != null && email != null && name != null) {
      return {
        'id': id,
        'email': email,
        'name': name,
        if (profileImage != null) 'profileImage': profileImage, // NEW
      };
    }
    return null;
  }

  Future<void> clearAll() async {
    await _init();
    await _prefs?.clear();
  }

  bool isLoggedIn() {
    final token = _prefs?.getString('auth_token');
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
    String? profileImage, // NEW: Optional profile image
  }) async {
    await _init();
    await _prefs!.setString(_userIdKey, id);
    await _prefs!.setString(_userEmailKey, email);
    await _prefs!.setString(_userNameKey, name);
    if (profileImage != null) {
      await _prefs!.setString(_profileImageKey, profileImage); // NEW
    }
  }

  // NEW: Save only profile image
  Future<void> saveProfileImage(String imageUrl) async {
    await _init();
    await _prefs!.setString(_profileImageKey, imageUrl);
  }
}
