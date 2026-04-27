import 'dart:ui';

abstract class LocaleState {}

class LocaleInitial extends LocaleState {}

class ChangeLocaleState extends LocaleState {
  final Locale locale;

  ChangeLocaleState(this.locale);
}
