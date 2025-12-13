// lib/feature/profile/presentation/bloc/create_account_state.dart

import 'package:equatable/equatable.dart';
import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/enums/habits.dart';

sealed class CreateAccountState extends Equatable {
  const CreateAccountState();

  @override
  List<Object?> get props => <Object?>[];
}

class CreateAccountData extends CreateAccountState {
  const CreateAccountData({
    this.selectedGender,
    this.selectedHabits = const <Habit>{},
    this.currentPage = 0,
  });

  final Gender? selectedGender;
  final Set<Habit> selectedHabits;
  final int currentPage;

  bool get isGenderSelected => selectedGender != null;

  bool get hasSelectedHabits => selectedHabits.isNotEmpty;

  bool get canProceed {
    if (currentPage == 0) {
      return isGenderSelected;
    }
    if (currentPage == 1) {
      return hasSelectedHabits;
    }
    return false;
  }

  CreateAccountData copyWith({
    final Gender? selectedGender,
    final Set<Habit>? selectedHabits,
    final int? currentPage,
  }) {
    return CreateAccountData(
      selectedGender: selectedGender ?? this.selectedGender,
      selectedHabits: selectedHabits ?? this.selectedHabits,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    selectedGender,
    selectedHabits,
    currentPage,
  ];
}

class CreateAccountLoading extends CreateAccountState {
  const CreateAccountLoading({required this.currentState});

  final CreateAccountData currentState;

  @override
  List<Object?> get props => [currentState];
}

class CreateAccountSuccess extends CreateAccountState {
  const CreateAccountSuccess({required this.savedData});

  final CreateAccountData savedData;

  @override
  List<Object?> get props => [savedData];
}

class CreateAccountError extends CreateAccountState {
  const CreateAccountError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}