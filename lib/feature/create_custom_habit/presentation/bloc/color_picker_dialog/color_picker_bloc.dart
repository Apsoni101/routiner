import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'color_picker_event.dart';
part 'color_picker_state.dart';

class ColorPickerBloc extends Bloc<ColorPickerEvent, ColorPickerState> {
  ColorPickerBloc({Color? selectedColor})
      : super(
    ColorPickerState(
      selectedColor: selectedColor ?? Colors.blue,
    ),
  ) {
    on<ColorSelected>(_onColorSelected);
  }

  void _onColorSelected(
      final ColorSelected event,
      final Emitter<ColorPickerState> emit,
      ) {
    emit(state.copyWith(selectedColor: event.color));
  }
}