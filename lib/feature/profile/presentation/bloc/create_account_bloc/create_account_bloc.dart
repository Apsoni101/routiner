// lib/feature/profile/presentation/bloc/create_account_bloc.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/profile/domain/usecase/create_account_local_usecase.dart';
import 'package:routiner/feature/profile/domain/usecase/create_account_remote_usecase.dart';
import 'package:routiner/feature/profile/presentation/bloc/create_account_bloc/create_account_event.dart';
import 'package:routiner/feature/profile/presentation/bloc/create_account_bloc/create_account_state.dart';
import 'package:uuid/uuid.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc({
    required this.createAccountUsecase,
    required this.remoteUsecase,
  }) : super(const CreateAccountData()) {
    on<GenderSelected>(_onGenderSelected);
    on<HabitToggled>(_onHabitToggled);
    on<NextPageRequested>(_onNextPageRequested);
    on<PreviousPageRequested>(_onPreviousPageRequested);
    on<SaveAccountRequested>(_onSaveAccountRequested);
  }

  final CreateAccountLocalUsecase createAccountUsecase;
  final CreateAccountRemoteUsecase remoteUsecase;
  final Uuid _uuid = const Uuid();

  void _onGenderSelected(
    final GenderSelected event,
    final Emitter<CreateAccountState> emit,
  ) {
    final CreateAccountData state = this.state as CreateAccountData;
    emit(state.copyWith(selectedGender: event.gender));
  }

  void _onHabitToggled(
    final HabitToggled event,
    final Emitter<CreateAccountState> emit,
  ) {
    final CreateAccountData state = this.state as CreateAccountData;
    final Set<Habit> habits = Set<Habit>.from(state.selectedHabits);

    habits.contains(event.habit)
        ? habits.remove(event.habit)
        : habits.add(event.habit);

    emit(state.copyWith(selectedHabits: habits));
  }

  void _onNextPageRequested(
    final NextPageRequested event,
    final Emitter<CreateAccountState> emit,
  ) {
    final CreateAccountData state = this.state as CreateAccountData;

    if (state.canProceed && state.currentPage < 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void _onPreviousPageRequested(
    final PreviousPageRequested event,
    final Emitter<CreateAccountState> emit,
  ) {
    final CreateAccountData state = this.state as CreateAccountData;

    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  Future<void> _onSaveAccountRequested(
    final SaveAccountRequested event,
    final Emitter<CreateAccountState> emit,
  ) async {
    final CreateAccountData state = this.state as CreateAccountData;

    if (state.selectedGender == null || state.selectedHabits.isEmpty) {
      emit(const CreateAccountError(message: 'Please complete all fields'));
      return;
    }

    emit(CreateAccountLoading(currentState: state));

    /// Convert Habit enum → CustomHabitEntity
    final List<CustomHabitEntity> habits = state.selectedHabits.map((
      final Habit habit,
    ) {
      return CustomHabitEntity(
        id: _uuid.v4(),
        habitIcon: habit,
        name: habit.label,
        goalValue: habit.goalValue,
        goalUnit: habit.goalUnit,
        goalFrequency: habit.goalFrequency,
        goalDays: habit.goalDays,
        type: habit.type,
        isAlarmEnabled: habit.isAlarmEnabled,
        alarmTime: habit.alarmTime,
        alarmDays: habit.alarmDays,
        createdAt: DateTime.now(),
      );
    }).toList();
    await createAccountUsecase.saveAccountData(
      gender: state.selectedGender!,
      habits: habits,
    );

    final Either<Failure, Unit> remoteResult = await remoteUsecase
        .saveAccountData(gender: state.selectedGender!, habits: habits);

    remoteResult.fold(
      (final Failure failure) {
        emit(CreateAccountError(message: failure.message));
      },
      (final Unit _) {
        emit(CreateAccountSuccess(savedData: state));
      },
    );
  }
}
