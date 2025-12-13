import 'package:flutter/material.dart';

enum AppLanguage {
  system, // system language
  english,
  hindi,
  spanish,
  arabic;

  String get label {
    switch (this) {
      case AppLanguage.system:
        return '🌐 System Language';
      case AppLanguage.english:
        return '🇺🇸 English';
      case AppLanguage.hindi:
        return '🇮🇳 Hindi';
      case AppLanguage.spanish:
        return '🇪🇸 Spanish';
      case AppLanguage.arabic:
        return '🇸🇦 Arabic';
    }
  }

  Locale? get locale {
    switch (this) {
      case AppLanguage.system:
        return null;
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.hindi:
        return const Locale('hi');
      case AppLanguage.spanish:
        return const Locale('es');
      case AppLanguage.arabic:
        return const Locale('ar');
    }
  }

  static AppLanguage fromLocale(final Locale? locale) {
    if (locale == null) {
      return AppLanguage.system;
    }
    if (locale.languageCode == 'en') {
      return AppLanguage.english;
    }
    if (locale.languageCode == 'hi') {
      return AppLanguage.hindi;
    }
    if (locale.languageCode == 'es') {
      return AppLanguage.spanish;
    }
    if (locale.languageCode == 'ar') {
      return AppLanguage.arabic;
    }
    return AppLanguage.system;
  }
}
