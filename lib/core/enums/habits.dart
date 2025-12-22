import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_colors.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/enums/habit_type.dart';
import 'package:routiner/core/enums/repeat_interval.dart';

enum Habit {
  sleep(
    id: 'sleep',
    label: 'Sleep',
    path: AppAssets.sleepIc,
    goalValue: 8,
    goalUnit: GoalUnit.hours,
    goalFrequency: RepeatInterval.daily,
    goalDays: Day.values,
    type: HabitType.daily,
    isAlarmEnabled: false,
    alarmTime: null,
    alarmDays: null,
    reminders: null,
    location: null,
    color: _c8C7CF6,
  ),
  waterPlant(
    id: 'waterPlant',
    label: 'Water Plant',
    path: AppAssets.waterPlantIc,
    goalValue: 1,
    goalUnit: GoalUnit.times,
    goalFrequency: RepeatInterval.daily,
    goalDays: Day.values,
    type: HabitType.daily,
    isAlarmEnabled: false,
    alarmTime: null,
    alarmDays: null,
    reminders: null,
    location: null,
    color: _cF5C842,
  ),
  journal(
    id: 'journal',
    label: 'Journal',
    path: AppAssets.journalIc,
    goalValue: 1,
    goalUnit: GoalUnit.pages,
    goalFrequency: RepeatInterval.daily,
    goalDays: Day.values,
    type: HabitType.daily,
    isAlarmEnabled: false,
    alarmTime: null,
    alarmDays: null,
    reminders: null,
    location: null,
    color: _cFA7298,
  ),
  study(
    id: 'study',
    label: 'Study',
    path: AppAssets.studyIc,
    goalValue: 2,
    goalUnit: GoalUnit.hours,
    goalFrequency: RepeatInterval.daily,
    goalDays: Day.values,
    type: HabitType.daily,
    isAlarmEnabled: false,
    alarmTime: null,
    alarmDays: null,
    reminders: null,
    location: null,
    color: _c5A63F1,
  ),
  meditate(
    id: 'meditate',
    label: 'Meditate',
    path: AppAssets.meditateIc,
    goalValue: 10,
    goalUnit: GoalUnit.minutes,
    goalFrequency: RepeatInterval.daily,
    goalDays: Day.values,
    type: HabitType.daily,
    isAlarmEnabled: false,
    alarmTime: null,
    alarmDays: null,
    reminders: null,
    location: null,
    color: _c12AFA3,
  ),
  book(
    id: 'book',
    label: 'Read Books',
    path: AppAssets.bookIc,
    goalValue: 2,
    goalUnit: GoalUnit.hours,
    goalFrequency: RepeatInterval.daily,
    goalDays: Day.values,
    type: HabitType.daily,
    isAlarmEnabled: false,
    alarmTime: null,
    alarmDays: null,
    reminders: null,
    location: null,
    color: _cF58A1F,
  ),
  run(
    id: 'run',
    label: 'Run',
    path: AppAssets.runIc,
    goalValue: 5,
    goalUnit: GoalUnit.kilometers,
    goalFrequency: RepeatInterval.daily,
    goalDays: Day.values,
    type: HabitType.daily,
    isAlarmEnabled: false,
    alarmTime: null,
    alarmDays: null,
    reminders: null,
    location: null,
    color: _c22D56A,
  ),
  water(
    id: 'water',
    label: 'Drink Water',
    path: AppAssets.waterIc,
    goalValue: 8,
    goalUnit: GoalUnit.ml,
    goalFrequency: RepeatInterval.daily,
    goalDays: Day.values,
    type: HabitType.daily,
    isAlarmEnabled: false,
    alarmTime: null,
    alarmDays: null,
    reminders: null,
    location: null,
    color: _c38C1FF,
  );

  const Habit({
    required this.id,
    required this.label,
    required this.path,
    required this.goalValue,
    required this.goalUnit,
    required this.goalFrequency,
    required this.goalDays,
    required this.type,
    required this.isAlarmEnabled,
    required this.alarmTime,
    required this.alarmDays,
    required this.reminders,
    required this.location,
    required this.color,
  });

  final String id;
  final String label;
  final String path;

  final int goalValue;
  final GoalUnit goalUnit;
  final RepeatInterval goalFrequency;
  final List<Day> goalDays;

  final HabitType type;
  final bool isAlarmEnabled;
  final TimeOfDay? alarmTime;
  final List<Day>? alarmDays;

  final List<TimeOfDay>? reminders;
  final String? location;

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
