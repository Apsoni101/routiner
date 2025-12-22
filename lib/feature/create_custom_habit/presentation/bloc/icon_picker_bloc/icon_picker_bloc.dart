import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/enums/habits.dart';

part 'icon_picker_event.dart';
part 'icon_picker_state.dart';

class IconPickerBloc extends Bloc<IconPickerEvent, IconPickerState> {
  IconPickerBloc({final IconData? selectedIcon, final Habit? selectedHabit})
      : super(
    IconPickerState(
      selectedIcon: selectedIcon,
      selectedHabit: selectedHabit,
    ),
  ) {
    on<IconSelected>(_onIconSelected);
    on<HabitSelected>(_onHabitSelected);
    on<TabChanged>(_onTabChanged);
  }

  void _onIconSelected(
      final IconSelected event,
      final Emitter<IconPickerState> emit,
      ) {
    emit(
      state.copyWith(
        selectedIcon: event.icon,
        selectedHabit: null, // Clear habit when icon is selected
        clearHabit: true,
      ),
    );
  }

  void _onHabitSelected(
      final HabitSelected event,
      final Emitter<IconPickerState> emit,
      ) {
    emit(
      state.copyWith(
        selectedHabit: event.habit,
        selectedIcon: null, // Clear icon when habit is selected
        clearIcon: true,
      ),
    );
  }

  void _onTabChanged(
      final TabChanged event,
      final Emitter<IconPickerState> emit,
      ) {
    emit(state.copyWith(tabIndex: event.index));
  }
}