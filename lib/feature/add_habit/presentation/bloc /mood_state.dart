part of 'mood_bloc.dart';

@immutable
sealed class MoodState extends Equatable {
  const MoodState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial state before any mood is loaded
final class MoodInitial extends MoodState {
  const MoodInitial();
}

/// Loading state while fetching mood data
final class MoodLoading extends MoodState {
  const MoodLoading();
}

/// Success state with mood data
final class MoodLoadSuccess extends MoodState {
  const MoodLoadSuccess(this.selectedMood, {this.timestamp});

  final Mood? selectedMood;
  final DateTime? timestamp;

  @override
  List<Object?> get props => <Object?>[selectedMood, timestamp];
}

/// Error state when mood operations fail
final class MoodError extends MoodState {
  const MoodError(
      this.message, {
        this.selectedMood,
        this.timestamp,
      });

  final String message;
  final Mood? selectedMood;
  final DateTime? timestamp;

  @override
  List<Object?> get props => <Object?>[message, selectedMood, timestamp];
}