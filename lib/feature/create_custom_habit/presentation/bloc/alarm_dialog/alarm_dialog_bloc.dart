import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/services/utils/alarm_service.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/alarm_dialog/alarm_dialog_event.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/alarm_dialog/alarm_dialog_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmService _alarmService;

  AlarmBloc(this._alarmService) : super(const AlarmState()) {
    on<ToggleAlarmEvent>(_onToggleAlarm);
    on<UpdateAlarmTimeEvent>(_onUpdateAlarmTime);
    on<UpdateAlarmDaysEvent>(_onUpdateAlarmDays);
    on<ScheduleAlarmEvent>(_onScheduleAlarm);
    on<CancelAlarmEvent>(_onCancelAlarm);
  }

  Future<void> _onToggleAlarm(
      ToggleAlarmEvent event,
      Emitter<AlarmState> emit,
      ) async {
    emit(state.copyWith(
      isAlarmEnabled: event.isEnabled,
      status: AlarmStatus.success,
    ));

    // If disabling, cancel all alarms
    if (!event.isEnabled && state.selectedDays.isNotEmpty) {
      try {
        for (final day in state.selectedDays) {
          await _alarmService.cancelAlarm(day.index);
        }
      } catch (e) {
        emit(state.copyWith(
          status: AlarmStatus.error,
          errorMessage: 'Failed to cancel alarms: $e',
        ));
      }
    }
  }

  Future<void> _onUpdateAlarmTime(
      UpdateAlarmTimeEvent event,
      Emitter<AlarmState> emit,
      ) async {
    emit(state.copyWith(
      selectedTime: event.time,
      status: AlarmStatus.success,
    ));

    // Reschedule alarms if enabled
    if (state.isAlarmEnabled && state.selectedDays.isNotEmpty) {
      await _rescheduleAlarms(emit);
    }
  }

  Future<void> _onUpdateAlarmDays(
      UpdateAlarmDaysEvent event,
      Emitter<AlarmState> emit,
      ) async {
    emit(state.copyWith(
      selectedDays: event.days,
      status: AlarmStatus.success,
    ));

    // Reschedule alarms if enabled
    if (state.isAlarmEnabled) {
      await _rescheduleAlarms(emit);
    }
  }

  Future<void> _onScheduleAlarm(
      ScheduleAlarmEvent event,
      Emitter<AlarmState> emit,
      ) async {
    if (!state.isAlarmEnabled || state.selectedDays.isEmpty) {
      return;
    }

    emit(state.copyWith(status: AlarmStatus.loading));

    try {
      await _rescheduleAlarms(emit);
    } catch (e) {
      emit(state.copyWith(
        status: AlarmStatus.error,
        errorMessage: 'Failed to schedule alarms: $e',
      ));
    }
  }

  Future<void> _onCancelAlarm(
      CancelAlarmEvent event,
      Emitter<AlarmState> emit,
      ) async {
    emit(state.copyWith(status: AlarmStatus.loading));

    try {
      for (final day in state.selectedDays) {
        await _alarmService.cancelAlarm(day.index);
      }
      emit(state.copyWith(status: AlarmStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: AlarmStatus.error,
        errorMessage: 'Failed to cancel alarms: $e',
      ));
    }
  }

  Future<void> _rescheduleAlarms(Emitter<AlarmState> emit) async {
    try {
      // Cancel existing alarms first
      for (final day in state.selectedDays) {
        await _alarmService.cancelAlarm(day.index);
      }

      // Schedule new alarms
      for (final day in state.selectedDays) {
        await _alarmService.scheduleAlarm(
          id: day.index,
          time: state.selectedTime,
          day: day,
          title: 'Workout Reminder',
          body: 'Time for your workout!',
        );
      }

      emit(state.copyWith(status: AlarmStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: AlarmStatus.error,
        errorMessage: 'Failed to reschedule alarms: $e',
      ));
    }
  }
}
