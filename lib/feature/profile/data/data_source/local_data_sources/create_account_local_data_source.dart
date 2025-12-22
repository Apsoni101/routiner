import 'package:flutter/material.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/enums/habit_type.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_hive_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_model.dart';

abstract class CreateAccountLocalDataSource {
  Future<void> saveGender(final Gender gender);

  Future<void> saveCustomHabits(final List<CustomHabitModel> habits);
}

class CreateAccountLocalDataSourceImpl implements CreateAccountLocalDataSource {
  CreateAccountLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  @override
  Future<void> saveGender(final Gender gender) async {
    await _hiveService.setString(HiveKeyConstants.genderKey, gender.name);
  }

  @override
  Future<void> saveCustomHabits(final List<CustomHabitModel> habits) async {
    final List<CustomHabitHiveModel> hiveHabits = habits
        .map(_mapModelToHiveModel)
        .toList();

    await _hiveService.setObjectList(
      HiveKeyConstants.customHabitsListKey,
      hiveHabits,
    );
  }
  // Helper methods for mapping
  CustomHabitHiveModel _mapModelToHiveModel(final CustomHabitModel model) {
    return CustomHabitHiveModel(
      id: model.id,
      name: model.name,
      iconCodePoint: model.icon?.codePoint,
      habitIcon: model.habitIcon?.name,
      habitIconPath: model.habitIcon?.path,
      colorValue: model.color?.value,
      goal: model.goal,
      reminders: model.reminders
          ?.map((final TimeOfDay r) => '${r.hour}:${r.minute}')
          .toList(),
      type: model.type?.toString(),
      location: model.location,
      createdAt: model.createdAt?.toIso8601String(),
      goalValue: model.goalValue,
      goalUnit: model.goalUnit?.name,
      goalFrequency: model.goalFrequency?.toString(),
      goalDays: model.goalDays?.map((final Day d) => d.toString()).toList(),
      isAlarmEnabled: model.isAlarmEnabled,
      alarmTime: model.alarmTime != null
          ? '${model.alarmTime!.hour}:${model.alarmTime!.minute}'
          : null,
      alarmDays: model.alarmDays?.map((final Day d) => d.toString()).toList(),
    );
  }

  CustomHabitModel _mapHiveModelToEntity(final CustomHabitHiveModel model) {
    return CustomHabitModel(
      id: model.id,
      name: model.name,
      icon: model.iconCodePoint != null
          ? IconData(model.iconCodePoint!, fontFamily: 'MaterialIcons')
          : null,
      habitIconPath: model.habitIconPath,
      habitIcon: model.habitIcon != null
          ? Habit.values.firstWhere(
            (final Habit e) => e.name == model.habitIcon,
        orElse: () => Habit.journal,
      )
          : null,
      color: model.colorValue != null ? Color(model.colorValue!) : null,
      goal: model.goal,
      reminders: model.reminders?.map((final String r) {
        final List<String> parts = r.split(':');
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }).toList(),
      type: model.type != null
          ? HabitType.values.firstWhere(
            (final HabitType e) => e.toString() == model.type,
        orElse: () => HabitType.daily,
      )
          : null,
      location: model.location,
      createdAt: model.createdAt != null
          ? DateTime.parse(model.createdAt!)
          : null,
      // NEW FIELDS
      goalValue: model.goalValue,
      goalUnit: model.goalUnit != null
          ? GoalUnit.values.firstWhere(
            (final GoalUnit e) => e.name == model.goalUnit,
        orElse: () => GoalUnit.times,
      )
          : null,
      goalFrequency: model.goalFrequency != null
          ? RepeatInterval.values.firstWhere(
            (final RepeatInterval e) => e.toString() == model.goalFrequency,
        orElse: () => RepeatInterval.daily,
      )
          : null,
      goalDays: model.goalDays?.map((final String d) {
        return Day.values.firstWhere(
              (final Day e) => e.toString() == d,
          orElse: () => Day.monday,
        );
      }).toList(),
      isAlarmEnabled: model.isAlarmEnabled,
      alarmTime: model.alarmTime != null
          ? TimeOfDay(
        hour: int.parse(model.alarmTime!.split(':')[0]),
        minute: int.parse(model.alarmTime!.split(':')[1]),
      )
          : null,
      alarmDays: model.alarmDays?.map((final String d) {
        return Day.values.firstWhere(
              (final Day e) => e.toString() == d,
          orElse: () => Day.monday,
        );
      }).toList(),
    );
  }
}
