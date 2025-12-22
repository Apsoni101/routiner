part of 'icon_picker_bloc.dart';

@immutable
sealed  class IconPickerEvent extends Equatable {
  const IconPickerEvent();

  @override
  List<Object?> get props => [];
}

class IconSelected extends IconPickerEvent {
  const IconSelected(this.icon);
  final IconData icon;

  @override
  List<Object?> get props => [icon];
}

class HabitSelected extends IconPickerEvent {
  const HabitSelected(this.habit);
  final Habit habit;

  @override
  List<Object?> get props => [habit];
}

class TabChanged extends IconPickerEvent {
  const TabChanged(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}
