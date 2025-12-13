import 'package:flutter/material.dart';
import 'package:routiner/core/enums/app_languages.dart';
import 'package:routiner/core/services/storage/shared_prefs_keys.dart';
import 'package:routiner/core/services/storage/shared_prefs_service.dart';

class LanguageController extends ValueNotifier<AppLanguage> {
  LanguageController(this._sharedPrefsService) : super(AppLanguage.system);

  final SharedPrefsService _sharedPrefsService;

  Future<void> initialize() async {
    final String? saved = _sharedPrefsService.getString(
      SharedPrefsKeys.languageTag,
    );
    if (saved != null) {
      value = AppLanguage.values.firstWhere(
        (final AppLanguage lang) => lang.name == saved,
        orElse: () => AppLanguage.system,
      );
    }
  }

  Future<void> setLanguage(final AppLanguage language) async {
    value = language;
    await _sharedPrefsService.setString(
      SharedPrefsKeys.languageTag,
      language.name,
    );
  }
}
