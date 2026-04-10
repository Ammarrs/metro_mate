import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(const SettingsState(
          language: AppLanguage.english,
          isDarkMode: false,
          isSoundEnabled: true,
          isPushNotificationsEnabled: true,
          isEmailNotificationsEnabled: false,
          isSmsAlertsEnabled: true,
          isMarketingEnabled: false,
          isBiometricEnabled: false,
        ));

  void toggleLanguage(AppLanguage language) =>
      emit(state.copyWith(language: language));

  void toggleDarkMode(bool value) => emit(state.copyWith(isDarkMode: value));

  void toggleSound(bool value) => emit(state.copyWith(isSoundEnabled: value));

  void togglePushNotifications(bool value) =>
      emit(state.copyWith(isPushNotificationsEnabled: value));

  void toggleEmailNotifications(bool value) =>
      emit(state.copyWith(isEmailNotificationsEnabled: value));

  void toggleSmsAlerts(bool value) =>
      emit(state.copyWith(isSmsAlertsEnabled: value));

  void toggleMarketing(bool value) =>
      emit(state.copyWith(isMarketingEnabled: value));

  void toggleBiometric(bool value) =>
      emit(state.copyWith(isBiometricEnabled: value));
}