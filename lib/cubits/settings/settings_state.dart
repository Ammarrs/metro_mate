enum AppLanguage { english, arabic }

class SettingsState {
  final AppLanguage language;
  final bool isDarkMode;
  final bool isSoundEnabled;
  final bool isPushNotificationsEnabled;
  final bool isEmailNotificationsEnabled;
  final bool isSmsAlertsEnabled;
  final bool isMarketingEnabled;
  final bool isBiometricEnabled;

  const SettingsState({
    required this.language,
    required this.isDarkMode,
    required this.isSoundEnabled,
    required this.isPushNotificationsEnabled,
    required this.isEmailNotificationsEnabled,
    required this.isSmsAlertsEnabled,
    required this.isMarketingEnabled,
    required this.isBiometricEnabled,
  });

  SettingsState copyWith({
    AppLanguage? language,
    bool? isDarkMode,
    bool? isSoundEnabled,
    bool? isPushNotificationsEnabled,
    bool? isEmailNotificationsEnabled,
    bool? isSmsAlertsEnabled,
    bool? isMarketingEnabled,
    bool? isBiometricEnabled,
  }) {
    return SettingsState(
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isPushNotificationsEnabled:
          isPushNotificationsEnabled ?? this.isPushNotificationsEnabled,
      isEmailNotificationsEnabled:
          isEmailNotificationsEnabled ?? this.isEmailNotificationsEnabled,
      isSmsAlertsEnabled: isSmsAlertsEnabled ?? this.isSmsAlertsEnabled,
      isMarketingEnabled: isMarketingEnabled ?? this.isMarketingEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}