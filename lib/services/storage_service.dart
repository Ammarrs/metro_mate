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
  static const String _profileImageKey = 'profile_image';
  static const String _onboardingSeenKey = 'onboarding_seen';

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

  /// Called once when the user finishes onboarding for the first time.
  Future<void> markOnboardingSeen() async {
    await _init();
    await _prefs!.setBool(_onboardingSeenKey, true);
  }

  Future<bool> hasSeenOnboarding() async {
    await _init();
    return _prefs?.getBool(_onboardingSeenKey) ?? false;
  }

  /// Clears auth data only — intentionally keeps onboarding flag so
  /// the splash screen never shows again after the first install.
  Future<void> clearAll() async {
    await _init();
    await _prefs?.remove(_tokenKey);
    await _prefs?.remove(_userIdKey);
    await _prefs?.remove(_userEmailKey);
    await _prefs?.remove(_userNameKey);
    await _prefs?.remove(_profileImageKey);
    // _onboardingSeenKey is deliberately NOT removed
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