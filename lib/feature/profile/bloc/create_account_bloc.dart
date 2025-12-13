// profile_event.dart
// profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
abstract class ProfileEvent {}

class GenderSelected extends ProfileEvent {
  final String gender;
  GenderSelected(this.gender);
}

class HabitToggled extends ProfileEvent {
  final String habit;
  HabitToggled(this.habit);
}

class NextPageRequested extends ProfileEvent {}

class PreviousPageRequested extends ProfileEvent {}

// profile_state.dart
class ProfileState {
  final String? selectedGender;
  final Set<String> selectedHabits;
  final int currentPage;

  ProfileState({
    this.selectedGender,
    Set<String>? selectedHabits,
    this.currentPage = 0,
  }) : selectedHabits = selectedHabits ?? {};

  bool get isGenderSelected => selectedGender != null;
  bool get hasSelectedHabits => selectedHabits.isNotEmpty;

  bool get canProceed {
    if (currentPage == 0) return isGenderSelected;
    if (currentPage == 1) return hasSelectedHabits;
    return false;
  }

  ProfileState copyWith({
    String? selectedGender,
    Set<String>? selectedHabits,
    int? currentPage,
  }) {
    return ProfileState(
      selectedGender: selectedGender ?? this.selectedGender,
      selectedHabits: selectedHabits ?? this.selectedHabits,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}



class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<GenderSelected>(_onGenderSelected);
    on<HabitToggled>(_onHabitToggled);
    on<NextPageRequested>(_onNextPageRequested);
    on<PreviousPageRequested>(_onPreviousPageRequested);
  }

  void _onGenderSelected(GenderSelected event, Emitter<ProfileState> emit) {
    emit(state.copyWith(selectedGender: event.gender));
  }

  void _onHabitToggled(HabitToggled event, Emitter<ProfileState> emit) {
    final habits = Set<String>.from(state.selectedHabits);
    if (habits.contains(event.habit)) {
      habits.remove(event.habit);
    } else {
      habits.add(event.habit);
    }
    emit(state.copyWith(selectedHabits: habits));
  }

  void _onNextPageRequested(NextPageRequested event, Emitter<ProfileState> emit) {
    if (state.canProceed && state.currentPage < 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void _onPreviousPageRequested(PreviousPageRequested event, Emitter<ProfileState> emit) {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }
}