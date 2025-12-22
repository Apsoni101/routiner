// lib/feature/habit_logs/domain/entity/habit_log_entity.dart

import 'package:equatable/equatable.dart';
import 'package:routiner/core/enums/log_status.dart';

class HabitLogEntity extends Equatable {
  const HabitLogEntity({
    required this.habitId,
    required this.date,
    this.id,
    this.status = LogStatus.pending,
    this.completedValue,
    this.goalValue,
    this.notes,
    this.completedAt,
  });

  final String? id;
  final String habitId;
  final DateTime date;
  final LogStatus status;
  final int? completedValue;
  final int? goalValue;
  final String? notes;
  final DateTime? completedAt;

  HabitLogEntity copyWith({
    final String? id,
    final String? habitId,
    final DateTime? date,
    final LogStatus? status,
    final int? completedValue,
    final int? goalValue,
    final String? notes,
    final DateTime? completedAt,
  }) {
    return HabitLogEntity(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      status: status ?? this.status,
      completedValue: completedValue ?? this.completedValue,
      goalValue: goalValue ?? this.goalValue,
      notes: notes ?? this.notes,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    habitId,
    date,
    status,
    completedValue,
    goalValue,
    notes,
    completedAt,
  ];
}
