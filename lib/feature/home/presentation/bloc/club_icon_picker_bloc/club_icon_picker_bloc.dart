// club_icon_picker_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'club_icon_picker_event.dart';
part 'club_icon_picker_state.dart';

class ClubIconPickerBloc
    extends Bloc<ClubIconPickerEvent, ClubIconPickerState> {
  ClubIconPickerBloc({
    final IconData? selectedIcon,
    final String? selectedImageUrl,
  }) : super(
    ClubIconPickerState(
      selectedIcon: selectedIcon,
      selectedImageUrl: selectedImageUrl,
    ),
  ) {
    on<IconSelected>(_onIconSelected);
    on<ImageUrlChanged>(_onImageUrlChanged);
    on<TabChanged>(_onTabChanged);
  }

  void _onIconSelected(
      final IconSelected event,
      final Emitter<ClubIconPickerState> emit,
      ) {
    emit(
      state.copyWith(
        selectedIcon: event.icon,
        selectedImageUrl: null,
        clearImageUrl: true,
      ),
    );
  }

  void _onImageUrlChanged(
      final ImageUrlChanged event,
      final Emitter<ClubIconPickerState> emit,
      ) {
    final String trimmedUrl = event.imageUrl.trim();
    emit(
      state.copyWith(
        selectedImageUrl: trimmedUrl.isEmpty ? null : trimmedUrl,
        selectedIcon: null,
        clearIcon: true,
      ),
    );
  }

  void _onTabChanged(
      final TabChanged event,
      final Emitter<ClubIconPickerState> emit,
      ) {
    emit(state.copyWith(tabIndex: event.index));
  }
}
