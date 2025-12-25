import 'package:flutter/material.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/core/services/storage/shared_prefs_keys.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController(this._hiveService) : super(ThemeMode.system);

  final HiveService _hiveService;

  /// Load theme from Hive
  Future<void> initialize() async {
    final String? modeName = _hiveService.getString(SharedPrefsKeys.themeMode);

    if (modeName != null) {
      value = ThemeMode.values.byName(modeName);
    } else {
      value = ThemeMode.system;
    }
  }

  /// Save theme to Hive
  Future<void> setTheme(final ThemeMode theme) async {
    value = theme;
    await _hiveService.setString(SharedPrefsKeys.themeMode, theme.name);
  }

  /// Switch between light and dark
  Future<void> toggleTheme() async {
    if (value == ThemeMode.light) {
      await setTheme(ThemeMode.dark);
    } else {
      await setTheme(ThemeMode.light);
    }
  }
}
