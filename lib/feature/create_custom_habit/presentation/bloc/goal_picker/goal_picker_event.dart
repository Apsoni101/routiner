part of 'goal_picker_bloc.dart';

@immutable
sealed class GoalPickerEvent extends Equatable {
  const GoalPickerEvent();

  @override
  List<Object> get props => [];
}

class UnitChanged extends GoalPickerEvent {
  final GoalUnit unit;

  const UnitChanged(this.unit);

  @override
  List<Object> get props => [unit];
}

class ValueChanged extends GoalPickerEvent {
  final int value;

  const ValueChanged(this.value);

  @override
  List<Object> get props => [value];
}
