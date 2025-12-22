import 'package:flutter/material.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/enums/habit_type.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';

class CustomHabitModel extends CustomHabitEntity {
  const CustomHabitModel({
    super.id,
    super.name,
    super.icon,
    super.habitIcon,
    super.habitIconPath,
    super.color,
    super.goal,
    super.reminders,
    super.type,
    super.location,
    super.createdAt,
    super.goalValue,
    super.goalUnit,
    super.goalFrequency,
    super.goalDays,
    super.isAlarmEnabled,
    super.alarmTime,
    super.alarmDays,
  });

  /// JSON → Model
  factory CustomHabitModel.fromJson(final Map<String, dynamic> json) {
    return CustomHabitModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      habitIconPath: json['habitIconPath']?.toString(),
      icon: json['icon'] != null
          ? IconData(json['icon'], fontFamily: 'MaterialIcons')
          : null,
      habitIcon: json['habitIcon'] != null
          ? Habit.values.firstWhere(
              (final Habit e) => e.name == json['habitIcon'],
              orElse: () => Habit.journal,
            )
          : null,
      color: json['color'] != null ? Color(json['color']) : null,
      goal: json['goal']?.toString(),
      reminders: (json['reminders'] is List)
          ? json['reminders'].map<TimeOfDay>((final r) {
              final List<String> parts = r.toString().split(':');
              return TimeOfDay(
                hour: int.parse(parts[0]),
                minute: int.parse(parts[1]),
              );
            }).toList()
          : null,
      type: json['type'] != null
          ? HabitType.values.firstWhere(
              (final HabitType e) => e.toString() == json['type'],
              orElse: () => HabitType.daily,
            )
          : null,
      location: json['location']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      goalValue: json['goalValue'] != null
          ? int.parse(json['goalValue'].toString())
          : null,
      goalUnit: json['goalUnit'] != null
          ? GoalUnit.values.firstWhere(
              (final GoalUnit e) => e.name == json['goalUnit'],
              orElse: () => GoalUnit.times,
            )
          : null,
      goalFrequency: json['goalFrequency'] != null
          ? RepeatInterval.values.firstWhere(
              (final RepeatInterval e) => e.toString() == json['goalFrequency'],
              orElse: () => RepeatInterval.daily,
            )
          : null,
      goalDays: json['goalDays'] != null
          ? (json['goalDays'] as List)
                .map<Day>(
                  (final d) => Day.values.firstWhere(
                    (final Day e) => e.toString() == d,
                    orElse: () => Day.monday,
                  ),
                )
                .toList()
          : null,
      isAlarmEnabled: json['isAlarmEnabled'] as bool?,
      alarmTime: json['alarmTime'] != null
          ? TimeOfDay(
              hour: int.parse(json['alarmTime'].toString().split(':')[0]),
              minute: int.parse(json['alarmTime'].toString().split(':')[1]),
            )
          : null,
      alarmDays: json['alarmDays'] != null
          ? (json['alarmDays'] as List)
                .map<Day>(
                  (final d) => Day.values.firstWhere(
                    (final Day e) => e.toString() == d,
                    orElse: () => Day.monday,
                  ),
                )
                .toList()
          : null,
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'habitIconPath': habitIconPath,
      'icon': icon?.codePoint,
      'habitIcon': habitIcon?.name,
      'color': color?.toARGB32(),
      'goal': goal,
      'reminders': reminders
          ?.map((final TimeOfDay r) => '${r.hour}:${r.minute}')
          .toList(),
      'type': type?.toString(),
      'location': location,
      'createdAt': createdAt?.toIso8601String(),
      'goalValue': goalValue,
      'goalUnit': goalUnit?.name,
      'goalFrequency': goalFrequency?.toString(),
      'goalDays': goalDays?.map((final Day d) => d.toString()).toList(),
      'isAlarmEnabled': isAlarmEnabled,
      'alarmTime': alarmTime != null
          ? '${alarmTime!.hour}:${alarmTime!.minute}'
          : null,
      'alarmDays': alarmDays?.map((final Day d) => d.toString()).toList(),
    };
  }


}
