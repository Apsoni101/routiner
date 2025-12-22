import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/enums/habit_type.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';

part 'custom_habit_hive_model.g.dart';

@HiveType(typeId: 1)
class CustomHabitHiveModel {
  const CustomHabitHiveModel({
    this.id,
    this.name,
    this.iconCodePoint,
    this.habitIconPath, // 👈 ADD THIS
    this.habitIcon,
    this.colorValue,
    this.goal,
    this.reminders,
    this.type,
    this.location,
    this.createdAt,
    this.goalValue,
    this.goalUnit,
    this.goalFrequency,
    this.goalDays,
    this.isAlarmEnabled,
    this.alarmTime,
    this.alarmDays,
  });

  /// Convert Entity → HiveModel
  factory CustomHabitHiveModel.fromEntity(final CustomHabitEntity entity) {
    return CustomHabitHiveModel(
      id: entity.id,
      name: entity.name,
      iconCodePoint: entity.icon?.codePoint,
      habitIcon: entity.habitIcon?.name,
      habitIconPath: entity.habitIcon?.path,
      colorValue: entity.color?.value,
      goal: entity.goal,
      reminders: entity.reminders
          ?.map(
            (final TimeOfDay t) =>
                '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
          )
          .toList(),
      type: entity.type?.name,
      location: entity.location,
      createdAt: entity.createdAt?.toIso8601String(),
      goalValue: entity.goalValue,
      goalUnit: entity.goalUnit?.name,
      goalFrequency: entity.goalFrequency?.name,
      goalDays: entity.goalDays?.map((final Day d) => d.name).toList(),
      isAlarmEnabled: entity.isAlarmEnabled,
      alarmTime: entity.alarmTime != null
          ? '${entity.alarmTime!.hour.toString().padLeft(2, '0')}:${entity.alarmTime!.minute.toString().padLeft(2, '0')}'
          : null,
      alarmDays: entity.alarmDays?.map((final Day d) => d.name).toList(),
    );
  }

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final int? iconCodePoint;

  @HiveField(3)
  final String? habitIcon;

  @HiveField(4)
  final int? colorValue;

  @HiveField(5)
  final String? goal;

  @HiveField(6)
  final List<String>? reminders; // store as HH:mm strings

  @HiveField(7)
  final String? type;

  @HiveField(8)
  final String? location;

  @HiveField(9)
  final String? createdAt;

  // Goal configuration
  @HiveField(10)
  final int? goalValue;

  @HiveField(11)
  final String? goalUnit;

  @HiveField(12)
  final String? goalFrequency;

  @HiveField(13)
  final List<String>? goalDays; // store as enum names

  // Alarm configuration
  @HiveField(14)
  final bool? isAlarmEnabled;

  @HiveField(15)
  final String? alarmTime;

  @HiveField(16)
  final List<String>? alarmDays; // store as enum names

  @HiveField(17)
  final String? habitIconPath;

  /// Convert HiveModel → Entity
  /// Convert HiveModel → Entity
  CustomHabitEntity toEntity() {
    return CustomHabitEntity(
      id: id,
      name: name,
      icon: iconCodePoint != null
          ? IconData(iconCodePoint!, fontFamily: 'MaterialIcons')
          : null,
      habitIconPath: habitIconPath,
      habitIcon: habitIcon != null && habitIcon!.isNotEmpty
          ? Habit.values.firstWhere(
            (final Habit h) => h.name == habitIcon,
        orElse: () => Habit.sleep,
      )
          : null,
      color: colorValue != null ? Color(colorValue!) : null,
      goal: goal,
      reminders: reminders != null && reminders!.isNotEmpty
          ? reminders!
          .where((final String t) => t.isNotEmpty && t.contains(':'))
          .map((final String t) {
        try {
          final List<String> parts = t.split(':');
          if (parts.length == 2) {
            return TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }
        } catch (e) {
          return null;
        }
        return null;
      })
          .whereType<TimeOfDay>()
          .toList()
          : null,
      type: type != null && type!.isNotEmpty
          ? HabitType.values.firstWhere(
            (final HabitType t) => t.name == type,
        orElse: () => HabitType.daily,
      )
          : null,
      location: location,
      createdAt: createdAt != null && createdAt!.isNotEmpty
          ? DateTime.tryParse(createdAt!)
          : null,
      goalValue: goalValue,
      goalUnit: goalUnit != null && goalUnit!.isNotEmpty
          ? GoalUnit.values.firstWhere(
            (final GoalUnit g) => g.name == goalUnit,
        orElse: () => GoalUnit.hours,
      )
          : null,
      goalFrequency: goalFrequency != null && goalFrequency!.isNotEmpty
          ? RepeatInterval.values.firstWhere(
            (final RepeatInterval r) => r.name == goalFrequency,
        orElse: () => RepeatInterval.daily,
      )
          : null,
      goalDays: goalDays != null && goalDays!.isNotEmpty
          ? goalDays!
          .where((final String d) => d.isNotEmpty)
          .map((final String d) {
        try {
          return Day.values.firstWhere(
                (final Day day) => day.name == d,
            orElse: () => Day.everyday,
          );
        } catch (e) {
          return null;
        }
      })
          .whereType<Day>()
          .toList()
          : null,
      isAlarmEnabled: isAlarmEnabled,
      alarmTime: alarmTime != null && alarmTime!.isNotEmpty && alarmTime!.contains(':')
          ? () {
        try {
          final List<String> parts = alarmTime!.split(':');
          if (parts.length == 2) {
            return TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }
        } catch (e) {
          return null;
        }
        return null;
      }()
          : null,
      alarmDays: alarmDays != null && alarmDays!.isNotEmpty
          ? alarmDays!
          .where((final String d) => d.isNotEmpty)
          .map((final String d) {
        try {
          return Day.values.firstWhere(
                (final Day day) => day.name == d,
            orElse: () => Day.everyday,
          );
        } catch (e) {
          return null;
        }
      })
          .whereType<Day>()
          .toList()
          : null,
    );
  }
}
