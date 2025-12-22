// alarm_dialog_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/enums/days.dart';

enum AlarmStatus { initial, loading, success, error }

class AlarmState extends Equatable {
  const AlarmState({
    this.isAlarmEnabled = false,
    this.selectedTime = const TimeOfDay(hour: 21, minute: 30),
    this.selectedDays = const <Day>[],
    this.status = AlarmStatus.initial,
    this.errorMessage,
  });

  final bool isAlarmEnabled;
  final TimeOfDay selectedTime;
  final List<Day> selectedDays;
  final AlarmStatus status;
  final String? errorMessage;

  AlarmState copyWith({
    final bool? isAlarmEnabled,
    final TimeOfDay? selectedTime,
    final List<Day>? selectedDays,
    final AlarmStatus? status,
    final String? errorMessage,
  }) {
    return AlarmState(
      isAlarmEnabled: isAlarmEnabled ?? this.isAlarmEnabled,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedDays: selectedDays ?? this.selectedDays,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    isAlarmEnabled,
    selectedTime,
    selectedDays,
    status,
    errorMessage,
  ];
}
