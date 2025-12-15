part of 'mood_bloc.dart';

@immutable
sealed class MoodState extends Equatable {
  const MoodState();

  @override
  List<Object?> get props => [];
}

class MoodInitial extends MoodState {
  const MoodInitial();
}

class MoodLoading extends MoodState {
  const MoodLoading();
}

class MoodLoadSuccess extends MoodState {
  const MoodLoadSuccess(this.selectedMood);

  final Mood? selectedMood;

  @override
  List<Object?> get props => [selectedMood];
}

class MoodSaveSuccess extends MoodState {
  const MoodSaveSuccess(this.selectedMood);

  final Mood selectedMood;

  @override
  List<Object?> get props => [selectedMood];
}

class MoodError extends MoodState {
  const MoodError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
