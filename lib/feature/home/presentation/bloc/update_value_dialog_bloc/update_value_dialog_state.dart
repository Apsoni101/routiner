part of 'update_value_dialog_bloc.dart';

@immutable
sealed class UpdateValueDialogState extends Equatable {
  const UpdateValueDialogState();

  @override
  List<Object?> get props => [];
}

class UpdateValueDialogInitial extends UpdateValueDialogState {
  const UpdateValueDialogInitial();
}

class UpdateValueDialogEditing extends UpdateValueDialogState {
  const UpdateValueDialogEditing({
    required this.value,
    this.errorMessage,
  });

  final String value;
  final String? errorMessage;

  @override
  List<Object?> get props => [value, errorMessage];
}

class UpdateValueDialogSubmitting extends UpdateValueDialogState {
  const UpdateValueDialogSubmitting();
}

class UpdateValueDialogSuccess extends UpdateValueDialogState {
  const UpdateValueDialogSuccess();

  @override
  List<Object?> get props => [];
}

class UpdateValueDialogError extends UpdateValueDialogState {
  const UpdateValueDialogError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}