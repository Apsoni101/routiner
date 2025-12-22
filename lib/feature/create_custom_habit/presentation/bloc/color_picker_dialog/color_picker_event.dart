part of 'color_picker_bloc.dart';

@immutable
sealed class ColorPickerEvent extends Equatable {
  const ColorPickerEvent();

  @override
  List<Object?> get props => [];
}

class ColorSelected extends ColorPickerEvent {
  const ColorSelected(this.color);
  final Color color;

  @override
  List<Object?> get props => [color];
}