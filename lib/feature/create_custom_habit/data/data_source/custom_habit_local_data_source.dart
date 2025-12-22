// lib/feature/create_custom_habit/data/local_data_source/custom_habit_local_data_source.dart
// UPDATED VERSION with new fields support

import 'package:flutter/material.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/enums/habit_type.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_hive_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_model.dart';

abstract class CustomHabitLocalDataSource {
  Future<void> saveCustomHabit(final CustomHabitModel habit);

  Future<List<CustomHabitModel>> getCustomHabits();

  Future<void> deleteCustomHabit(final String id);

  Future<void> updateCustomHabit(final CustomHabitModel habit);
}

class CustomHabitLocalDataSourceImpl implements CustomHabitLocalDataSource {
  CustomHabitLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  @override
  Future<void> saveCustomHabit(final CustomHabitModel habit) async {
    final CustomHabitHiveModel hiveModel = _mapModelToHiveModel(habit);

    final List<CustomHabitHiveModel> existingHabits =
        _hiveService.getObjectList<CustomHabitHiveModel>(
                HiveKeyConstants.customHabitsListKey,
              ) ??
              <CustomHabitHiveModel>[]
          ..add(hiveModel);

    await _hiveService.setObjectList(
      HiveKeyConstants.customHabitsListKey,
      existingHabits,
    );
    await _hiveService.setObject(
      '${HiveKeyConstants.customHabitsKey}_${habit.id}',
      hiveModel,
    );
  }

  @override
  Future<List<CustomHabitModel>> getCustomHabits() async {
    final List<CustomHabitHiveModel>? hiveModels = _hiveService
        .getObjectList<CustomHabitHiveModel>(
          HiveKeyConstants.customHabitsListKey,
        );

    if (hiveModels == null || hiveModels.isEmpty) {
      return <CustomHabitModel>[];
    }

    return hiveModels.map(_mapHiveModelToEntity).toList();
  }

  @override
  Future<void> deleteCustomHabit(final String id) async {
    final List<CustomHabitHiveModel>? existingHabits = _hiveService
        .getObjectList<CustomHabitHiveModel>(
          HiveKeyConstants.customHabitsListKey,
        );

    if (existingHabits != null) {
      existingHabits.removeWhere(
        (final CustomHabitHiveModel habit) => habit.id == id,
      );
      await _hiveService.setObjectList(
        HiveKeyConstants.customHabitsListKey,
        existingHabits,
      );
    }

    await _hiveService.remove('${HiveKeyConstants.customHabitsKey}_$id');
  }

  @override
  Future<void> updateCustomHabit(final CustomHabitModel habit) async {
    final CustomHabitHiveModel updatedModel = _mapModelToHiveModel(habit);

    final List<CustomHabitHiveModel>? existingHabits = _hiveService
        .getObjectList<CustomHabitHiveModel>(
          HiveKeyConstants.customHabitsListKey,
        );

    if (existingHabits != null) {
      final int index = existingHabits.indexWhere(
        (final CustomHabitHiveModel h) => h.id == habit.id,
      );
      if (index != -1) {
        existingHabits[index] = updatedModel;
        await _hiveService.setObjectList(
          HiveKeyConstants.customHabitsListKey,
          existingHabits,
        );
      }
    }

    await _hiveService.setObject(
      '${HiveKeyConstants.customHabitsKey}_${habit.id}',
      updatedModel,
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
          ? () {
              final List<String> parts = model.alarmTime!.split(':');

              final int hour =
                  int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0;
              final int minute =
                  int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;

              return TimeOfDay(hour: hour, minute: minute);
            }()
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
