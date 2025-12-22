part of 'update_value_dialog_bloc.dart';

@immutable
sealed class UpdateValueDialogEvent extends Equatable {
  const UpdateValueDialogEvent();

  @override
  List<Object?> get props => [];
}

class InitializeDialog extends UpdateValueDialogEvent {
  const InitializeDialog({
    required this.log,
    required this.maxValue,
    required this.currentValue,
  });

  final HabitLogEntity log;
  final int maxValue;
  final int currentValue;

  @override
  List<Object?> get props => [log, maxValue, currentValue];
}

class ValueChanged extends UpdateValueDialogEvent {
  const ValueChanged(this.value);
  final String value;

  @override
  List<Object?> get props => [value];
}

class SubmitValue extends UpdateValueDialogEvent {
  const SubmitValue();
}

class ResetDialog extends UpdateValueDialogEvent {
  const ResetDialog();
}