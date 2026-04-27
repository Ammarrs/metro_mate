import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocaleState {}

class LocaleInitial extends LocaleState {}

class ChangeLocaleState extends LocaleState {
  final Locale locale;
  ChangeLocaleState(this.locale);
}

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleInitial()) {
    loadSavedLanguage();
  }

  Locale currentLocale = const Locale('en');

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('lang');

    if (langCode != null) {
      currentLocale = Locale(langCode);
    } else {
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

      if (systemLocale.languageCode == 'ar') {
        currentLocale = const Locale('ar');
      } else {
        currentLocale = const Locale('en');
      }
    }

    emit(ChangeLocaleState(currentLocale));
  }

  Future<void> _saveLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', langCode);
  }

  void changeToArabic() async {
    if (currentLocale.languageCode == 'ar') return;

    currentLocale = const Locale('ar');
    await _saveLanguage('ar');
    emit(ChangeLocaleState(currentLocale));
  }

  void changeToEnglish() async {
    if (currentLocale.languageCode == 'en') return;

    currentLocale = const Locale('en');
    await _saveLanguage('en');
    emit(ChangeLocaleState(currentLocale));
  }

  void toggleLanguage() {
    currentLocale.languageCode == 'en' ? changeToArabic() : changeToEnglish();
  }
}
