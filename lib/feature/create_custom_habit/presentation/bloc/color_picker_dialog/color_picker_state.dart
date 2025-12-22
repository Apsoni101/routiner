part of 'color_picker_bloc.dart';

class ColorPickerState extends Equatable {
  const ColorPickerState({
    required this.selectedColor,
  });

  final Color selectedColor;

  ColorPickerState copyWith({
    final Color? selectedColor,
  }) {
    return ColorPickerState(
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  @override
  List<Object?> get props => [selectedColor];
}