// lib/feature/profile/presentation/bloc/create_account_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/feature/profile/domain/usecase/create_account_usecase.dart';
import 'package:routiner/feature/profile/presentation/bloc/create_account_event.dart';
import 'package:routiner/feature/profile/presentation/bloc/create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc(this._saveAccountDataUseCase)
    : super(const CreateAccountData()) {
    on<GenderSelected>(_onGenderSelected);
    on<HabitToggled>(_onHabitToggled);
    on<NextPageRequested>(_onNextPageRequested);
    on<PreviousPageRequested>(_onPreviousPageRequested);
    on<SaveAccountRequested>(_onSaveAccountRequested);
  }

  final CreateAccountUsecase _saveAccountDataUseCase;

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

    if (habits.contains(event.habit)) {
      habits.remove(event.habit);
    } else {
      habits.add(event.habit);
    }

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
      emit(CreateAccountError(message: 'Please complete all fields'));
      return;
    }

    emit(CreateAccountLoading(currentState: state));

    await _saveAccountDataUseCase.createAccount(
      gender: state.selectedGender!,
      habits: state.selectedHabits,
    );
    emit(CreateAccountSuccess(savedData: state));
  }
}
