part of 'mood_bloc.dart';

@immutable
sealed class MoodEvent extends Equatable {
  const MoodEvent();

  @override
  List<Object?> get props => [];
}

class MoodSelected extends MoodEvent {
  const MoodSelected(this.mood);

  final Mood mood;

  @override
  List<Object?> get props => [mood];
}

class MoodCleared extends MoodEvent {
  const MoodCleared();
}

class MoodLoaded extends MoodEvent {
  const MoodLoaded();
}
