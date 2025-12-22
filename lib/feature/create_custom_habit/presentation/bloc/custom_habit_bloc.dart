// ============================================================================
// FILE: custom_habit_bloc.dart
// ============================================================================

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/enums/habit_type.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/goal_value.dart';
import 'package:routiner/feature/create_custom_habit/domain/usecase/create_custom_habit_local_use_case.dart';
import 'package:routiner/feature/create_custom_habit/domain/usecase/create_custom_habit_remote_usecase.dart';
import 'package:uuid/uuid.dart';

part 'custom_habit_event.dart';

part 'custom_habit_state.dart';

class CreateCustomHabitBloc
    extends Bloc<CreateCustomHabitEvent, CreateCustomHabitState> {
  CreateCustomHabitBloc({
    required final CreateCustomHabitLocalUsecase createCustomHabitLocalUsecase,
    required final CreateCustomHabitRemoteUsecase
    createCustomHabitRemoteUsecase,
  }) : _createCustomHabitLocalUsecase = createCustomHabitLocalUsecase,
       _createCustomHabitRemoteUsecase = createCustomHabitRemoteUsecase,
       super(const CreateCustomHabitState()) {
    on<NameChanged>(_onNameChanged);
    on<IconSelected>(_onIconSelected);
    on<HabitIconSelected>(_onHabitIconSelected);
    on<ColorSelected>(_onColorSelected);
    on<GoalValueChanged>(_onGoalValueChanged);
    on<ReminderAdded>(_onReminderAdded);
    on<ReminderRemoved>(_onReminderRemoved);
    on<TypeSelected>(_onTypeSelected);
    on<LocationChanged>(_onLocationChanged);
    on<SaveHabitPressed>(_onSaveHabitPressed);
    on<GoalFrequencyChanged>(_onGoalFrequencyChanged);
    on<GoalDaysChanged>(_onGoalDaysChanged);
  }

  final CreateCustomHabitLocalUsecase _createCustomHabitLocalUsecase;
  final CreateCustomHabitRemoteUsecase _createCustomHabitRemoteUsecase;

  void _onGoalDaysChanged(
    final GoalDaysChanged event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    emit(state.copyWith(goalDays: event.days));
  }

  void _onNameChanged(
    final NameChanged event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    emit(
      state.copyWith(name: event.name, isValid: event.name.trim().isNotEmpty),
    );
  }

  void _onIconSelected(
    final IconSelected event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    emit(
      state.copyWith(
        selectedIcon: event.icon,
        clearHabit: true,
      ),
    );
  }

  void _onHabitIconSelected(
    final HabitIconSelected event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    emit(
      state.copyWith(
        selectedHabit: event.habit,
        clearIcon: true,
      ),
    );
  }

  void _onColorSelected(
    final ColorSelected event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    emit(state.copyWith(selectedColor: event.color));
  }

  void _onGoalValueChanged(
    final GoalValueChanged event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    emit(
      state.copyWith(
        goalValue: event.goalValue.value,
        goalUnit: event.goalValue.unit,
      ),
    );
  }

  void _onReminderAdded(
    final ReminderAdded event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    final List<TimeOfDay> updatedReminders = List<TimeOfDay>.from(
      state.reminders,
    )..add(event.reminder);
    emit(state.copyWith(reminders: updatedReminders));
  }

  void _onReminderRemoved(
    final ReminderRemoved event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    final List<TimeOfDay> updatedReminders = List<TimeOfDay>.from(
      state.reminders,
    )..removeAt(event.index);
    emit(state.copyWith(reminders: updatedReminders));
  }

  void _onTypeSelected(
    final TypeSelected event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    emit(state.copyWith(selectedType: event.type));
  }

  void _onLocationChanged(
    final LocationChanged event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    emit(state.copyWith(location: event.location));
  }

  void _onGoalFrequencyChanged(
    final GoalFrequencyChanged event,
    final Emitter<CreateCustomHabitState> emit,
  ) {
    emit(state.copyWith(goalFrequency: event.frequency));
  }
  Future<void> _onSaveHabitPressed(
      final SaveHabitPressed event,
      final Emitter<CreateCustomHabitState> emit,
      ) async {
    if (!state.isValid) {
      emit(state.copyWith(errorMessage: 'Please enter a habit name'));
      return;
    }

    if (state.selectedIcon == null && state.selectedHabit == null) {
      emit(state.copyWith(errorMessage: 'Please select an icon'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    /// ================== DUPLICATE NAME CHECK ==================

    final List<CustomHabitEntity> existingHabits =
    await _createCustomHabitLocalUsecase.getCustomHabits();

    final bool nameAlreadyExists = existingHabits.any(
          (final CustomHabitEntity h) =>
      h.name?.toLowerCase() == state.name.trim().toLowerCase(),
    );

    if (nameAlreadyExists) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Habit with this name already exists',
        ),
      );
      return;
    }


    final CustomHabitEntity habit = CustomHabitEntity(
      id: const Uuid().v4(),
      name: state.name.trim(),
      icon: state.selectedIcon,
      habitIcon: state.selectedHabit,
      color: state.selectedColor,
      goal: state.goal,
      reminders: state.reminders,
      type: state.selectedType,
      location: state.location,
      createdAt: DateTime.now(),
      goalValue: state.goalValue,
      goalUnit: state.goalUnit,
      goalFrequency: state.goalFrequency,
      goalDays: state.goalDays,
      isAlarmEnabled: event.isAlarmEnabled,
      alarmTime: event.alarmTime ?? TimeOfDay.now(),
      alarmDays: event.alarmDays,
    );

    final Either<Failure, String> remoteResult =
    await _createCustomHabitRemoteUsecase(habit);

    await remoteResult.fold(
          (final Failure failure) async {
        await _createCustomHabitLocalUsecase.createCustomHabit(habit);
        emit(
          state.copyWith(
            isLoading: false,
            isSaved: true,
            errorMessage:
            'Saved locally. Remote sync failed: ${failure.message}',
          ),
        );
      },
          (final String habitId) async {
        await _createCustomHabitLocalUsecase.createCustomHabit(habit);
        emit(
          state.copyWith(isLoading: false, isSaved: true, errorMessage: null),
        );
      },
    );
  }

}
