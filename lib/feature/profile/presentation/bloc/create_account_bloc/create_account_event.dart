// lib/feature/profile/presentation/bloc/create_account_event.dart

import 'package:equatable/equatable.dart';
import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/enums/habits.dart';

sealed class CreateAccountEvent extends Equatable {
  const CreateAccountEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class GenderSelected extends CreateAccountEvent {
  const GenderSelected(this.gender);

  final Gender gender;

  @override
  List<Object?> get props => <Object?>[gender];
}

class HabitToggled extends CreateAccountEvent {
  const HabitToggled(this.habit);

  final Habit habit;

  @override
  List<Object?> get props => <Object?>[habit];
}

class NextPageRequested extends CreateAccountEvent {
  const NextPageRequested();
}

class PreviousPageRequested extends CreateAccountEvent {
  const PreviousPageRequested();
}

class SaveAccountRequested extends CreateAccountEvent {
  const SaveAccountRequested();
}