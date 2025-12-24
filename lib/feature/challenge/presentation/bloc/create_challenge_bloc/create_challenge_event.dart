part of 'create_challenge_bloc.dart';

@immutable
sealed class CreateChallengeEvent extends Equatable {
  const CreateChallengeEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserHabits extends CreateChallengeEvent {
  const LoadUserHabits();
}

class UpdateTitle extends CreateChallengeEvent {
  const UpdateTitle(this.title);
  final String title;

  @override
  List<Object?> get props => [title];
}

class UpdateDescription extends CreateChallengeEvent {
  const UpdateDescription(this.description);
  final String description;

  @override
  List<Object?> get props => [description];
}

class UpdateEmoji extends CreateChallengeEvent {
  const UpdateEmoji(this.emoji);
  final Emoji emoji;

  @override
  List<Object?> get props => [emoji];
}

class UpdateDuration extends CreateChallengeEvent {
  const UpdateDuration(this.duration);
  final int duration;

  @override
  List<Object?> get props => [duration];
}

class UpdateDurationType extends CreateChallengeEvent {
  const UpdateDurationType(this.durationType);
  final ChallengeDurationType durationType;

  @override
  List<Object?> get props => [durationType];
}

class UpdateSelectedHabits extends CreateChallengeEvent {
  const UpdateSelectedHabits(this.habits);
  final List<CustomHabitEntity> habits;

  @override
  List<Object?> get props => [habits];
}

// FIXED: Removed userId parameter - BLoC will fetch it internally
class CreateChallengePressed extends CreateChallengeEvent {
  const CreateChallengePressed();
}