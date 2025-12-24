part of 'mood_bloc.dart';

@immutable
sealed class MoodEvent extends Equatable {
  const MoodEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Event to load initial mood state
final class MoodLoaded extends MoodEvent {
  const MoodLoaded();
}

/// Event when user selects a mood
final class MoodSelected extends MoodEvent {
  const MoodSelected(this.mood);

  final Mood mood;

  @override
  List<Object?> get props => <Object?>[mood];
}

/// Event to clear current mood state
final class MoodCleared extends MoodEvent {
  const MoodCleared();
}

/// Event to sync with remote data
final class MoodSyncRequested extends MoodEvent {
  const MoodSyncRequested();
}