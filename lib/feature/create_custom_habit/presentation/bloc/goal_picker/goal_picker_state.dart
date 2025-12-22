part of 'goal_picker_bloc.dart';

@immutable
sealed class GoalPickerState extends Equatable {
  const GoalPickerState();

  @override
  List<Object> get props => [];
}

class GoalPickerReady extends GoalPickerState {
  final GoalUnit unit;
  final int value;
  final List<int> valueOptions;

  const GoalPickerReady({
    required this.unit,
    required this.value,
    required this.valueOptions,
  });

  @override
  List<Object> get props => [unit, value, valueOptions];
}
