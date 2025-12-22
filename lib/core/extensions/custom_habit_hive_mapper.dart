import 'package:flutter/material.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/enums/habit_type.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_hive_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_model.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/goal_picker_dialog.dart';

extension CustomHabitHiveMapper on CustomHabitModel {
  CustomHabitHiveModel toHive() {
    return CustomHabitHiveModel(
      id: id,
      name: name,
      iconCodePoint: icon?.codePoint,
      habitIcon: habitIcon?.name,
      colorValue: color?.toARGB32(),
      goal: goal,
      reminders: reminders
          ?.map((final TimeOfDay r) => '${r.hour}:${r.minute}')
          .toList(),
      type: type?.name,
      location: location,
      createdAt: createdAt?.toIso8601String(),
      goalValue: goalValue,
      goalUnit: goalUnit?.name,
      goalFrequency: goalFrequency?.name,
      goalDays: goalDays?.map((final Day d) => d.name).toList(),
      isAlarmEnabled: isAlarmEnabled,
      alarmTime: alarmTime != null
          ? '${alarmTime!.hour}:${alarmTime!.minute}'
          : null,
      alarmDays: alarmDays?.map((final Day d) => d.name).toList(),
    );
  }
}

extension CustomHabitModelMapper on CustomHabitHiveModel {
  CustomHabitModel toModel() {
    return CustomHabitModel(
      id: id,
      name: name,
      icon: iconCodePoint != null
          ? IconData(iconCodePoint!, fontFamily: 'MaterialIcons')
          : null,
      habitIcon: habitIcon != null
          ? Habit.values.firstWhere(
              (final Habit e) => e.name == habitIcon,
              orElse: () => Habit.journal,
            )
          : null,
      color: colorValue != null ? Color(colorValue!) : null,
      goal: goal,
      reminders: reminders?.map((final String r) {
        final List<String> parts = r.split(':');
        if (parts.length == 2) {
          final int hour = int.tryParse(parts[0]) ?? 9;
          final int minute = int.tryParse(parts[1]) ?? 0;
          return TimeOfDay(hour: hour, minute: minute);
        }
        return const TimeOfDay(hour: 9, minute: 0);
      }).toList(),
      type: type != null
          ? HabitType.values.firstWhere(
              (final HabitType e) => e.name == type,
              orElse: () => HabitType.daily,
            )
          : null,
      location: location,
      createdAt: createdAt != null
          ? DateTime.tryParse(createdAt!) ?? DateTime.now()
          : null,

      goalValue: goalValue ?? 1,

      goalUnit: goalUnit != null
          ? GoalUnit.values.firstWhere(
              (final GoalUnit e) => e.name == goalUnit,
              orElse: () => GoalUnit.times,
            )
          : GoalUnit.times,
      goalFrequency: goalFrequency != null
          ? RepeatInterval.values.firstWhere(
              (final RepeatInterval e) => e.name == goalFrequency,
              orElse: () => RepeatInterval.daily,
            )
          : null,
      goalDays: goalDays?.map((final String d) {
        return Day.values.firstWhere(
          (final Day e) => e.name == d,
          orElse: () => Day.monday,
        );
      }).toList(),

      isAlarmEnabled: isAlarmEnabled ?? false,

      alarmTime: alarmTime != null
          ? () {
              final List<String> parts = alarmTime!.split(':');
              if (parts.length == 2) {
                final int hour = int.tryParse(parts[0]) ?? 9;
                final int minute = int.tryParse(parts[1]) ?? 0;
                return TimeOfDay(hour: hour, minute: minute);
              }
              return const TimeOfDay(hour: 9, minute: 0);
            }()
          : null,
      alarmDays: alarmDays?.map((final String d) {
        return Day.values.firstWhere(
          (final Day e) => e.name == d,
          orElse: () => Day.monday,
        );
      }).toList(),
    );
  }
}
