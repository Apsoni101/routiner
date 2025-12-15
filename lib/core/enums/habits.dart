import 'dart:ui';

import 'package:routiner/core/constants/app_colors.dart';
import 'package:routiner/core/constants/asset_constants.dart';

enum Habit {
  sleep(
    label: 'Sleep',
    path: AppAssets.sleepIc,
    defaultValue: 8,
    unit: 'hrs',
    color: _c8C7CF6,
  ),
  waterPlant(
    label: 'Water Plant',
    path: AppAssets.waterPlantIc,
    defaultValue: 1,
    unit: 'times',
    color: _cF5C842,
  ),
  journal(
    label: 'Journal',
    path: AppAssets.journalIc,
    defaultValue: 1,
    unit: 'page',
    color: _cFA7298,
  ),
  study(
    label: 'Study',
    path: AppAssets.studyIc,
    defaultValue: 2,
    unit: 'hrs',
    color: _c5A63F1,
  ),
  meditate(
    label: 'Meditate',
    path: AppAssets.meditateIc,
    defaultValue: 10,
    unit: 'min',
    color: _c12AFA3,
  ),
  book(
    label: 'Read Books',
    path: AppAssets.bookIc,
    defaultValue: 2,
    unit: 'hrs',
    color: _cF58A1F,
  ),
  run(
    label: 'Run',
    path: AppAssets.runIc,
    defaultValue: 5,
    unit: 'km',
    color: _c22D56A,
  ),
  water(
    label: 'Drink Water',
    path: AppAssets.waterIc,
    defaultValue: 8,
    unit: 'ml',
    color: _c38C1FF,
  );

  const Habit({
    required this.label,
    required this.path,
    required this.defaultValue,
    required this.unit,
    required this.color,
  });

  final String label;
  final String path;
  final int defaultValue;
  final String unit;
  final Color Function(AppThemeColors colors) color;
}

Color _c8C7CF6(final AppThemeColors c) => c.c8C7CF6;

Color _c22D56A(final AppThemeColors c) => c.c22D56A;

Color _c38C1FF(final AppThemeColors c) => c.c38C1FF;

Color _cF5C842(final AppThemeColors c) => c.cF5C842;

Color _cFA7298(final AppThemeColors c) => c.cFA7298;

Color _c5A63F1(final AppThemeColors c) => c.c5A63F1;

Color _c12AFA3(final AppThemeColors c) => c.c12AFA3;

Color _cF58A1F(final AppThemeColors c) => c.cF58A1F;
