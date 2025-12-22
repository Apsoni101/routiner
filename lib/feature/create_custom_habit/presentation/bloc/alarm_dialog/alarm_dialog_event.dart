import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/enums/days.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object?> get props => [];
}

class ToggleAlarmEvent extends AlarmEvent {
  final bool isEnabled;

  const ToggleAlarmEvent(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class UpdateAlarmTimeEvent extends AlarmEvent {
  final TimeOfDay time;

  const UpdateAlarmTimeEvent(this.time);

  @override
  List<Object?> get props => [time];
}

class UpdateAlarmDaysEvent extends AlarmEvent {
  final List<Day> days;

  const UpdateAlarmDaysEvent(this.days);

  @override
  List<Object?> get props => [days];
}

class ScheduleAlarmEvent extends AlarmEvent {
  const ScheduleAlarmEvent();
}

class CancelAlarmEvent extends AlarmEvent {
  const CancelAlarmEvent();
}