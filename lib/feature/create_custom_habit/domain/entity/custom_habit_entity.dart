import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/enums/habit_type.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_model.dart';

class CustomHabitEntity extends Equatable {
  const CustomHabitEntity({
    this.id,
    this.name,
    this.icon,
    this.habitIconPath,
    this.habitIcon,
    this.color,
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

  final String? habitIconPath;
  final String? id;
  final String? name;
  final IconData? icon;
  final Habit? habitIcon;
  final Color? color;
  final String? goal;
  final List<TimeOfDay>? reminders;
  final HabitType? type;
  final String? location;
  final DateTime? createdAt;

  final int? goalValue;
  final GoalUnit? goalUnit;
  final RepeatInterval? goalFrequency;
  final List<Day>? goalDays;

  final bool? isAlarmEnabled;
  final TimeOfDay? alarmTime;
  final List<Day>? alarmDays;

  /// Convert entity to model
  CustomHabitModel toModel() {
    return CustomHabitModel(
      id: id,
      name: name,
      icon: icon,
      habitIcon: habitIcon,
      color: color,
      goal: goal,
      reminders: reminders,
      type: type,
      location: location,
      createdAt: createdAt,
      goalValue: goalValue,
      goalUnit: goalUnit,
      goalFrequency: goalFrequency,
      goalDays: goalDays,
      isAlarmEnabled: isAlarmEnabled,
      alarmTime: alarmTime,
      alarmDays: alarmDays,
    );
  }

  CustomHabitEntity copyWith({
    final String? id,
    final String? name,
    final IconData? icon,
    final String? habitIconPath,
    final Habit? habitIcon,
    final Color? color,
    final String? goal,
    final List<TimeOfDay>? reminders,
    final HabitType? type,
    final String? location,
    final DateTime? createdAt,
    final int? goalValue,
    final GoalUnit? goalUnit,
    final RepeatInterval? goalFrequency,
    final List<Day>? goalDays,
    final bool? isAlarmEnabled,
    final TimeOfDay? alarmTime,
    final List<Day>? alarmDays,
  }) {
    return CustomHabitEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      habitIconPath: habitIconPath ?? this.habitIconPath,
      habitIcon: habitIcon ?? this.habitIcon,
      color: color ?? this.color,
      goal: goal ?? this.goal,
      reminders: reminders ?? this.reminders,
      type: type ?? this.type,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      goalValue: goalValue ?? this.goalValue,
      goalUnit: goalUnit ?? this.goalUnit,
      goalFrequency: goalFrequency ?? this.goalFrequency,
      goalDays: goalDays ?? this.goalDays,
      isAlarmEnabled: isAlarmEnabled ?? this.isAlarmEnabled,
      alarmTime: alarmTime ?? this.alarmTime,
      alarmDays: alarmDays ?? this.alarmDays,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    icon,
    habitIconPath,
    habitIcon,
    color,
    goal,
    reminders,
    type,
    location,
    createdAt,
    goalValue,
    goalUnit,
    goalFrequency,
    goalDays,
    isAlarmEnabled,
    alarmTime,
    alarmDays,
  ];
}
