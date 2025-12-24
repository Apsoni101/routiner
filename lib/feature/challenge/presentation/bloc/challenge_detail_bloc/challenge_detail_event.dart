part of 'challenge_detail_bloc.dart';

abstract class ChallengeDetailEvent extends Equatable {
  const ChallengeDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadChallengeDetail extends ChallengeDetailEvent {
  const LoadChallengeDetail(this.challengeId);

  final String challengeId;

  @override
  List<Object?> get props => [challengeId];
}

class JoinChallenge extends ChallengeDetailEvent {
  const JoinChallenge({required this.challengeId});

  final String challengeId;

  @override
  List<Object?> get props => [challengeId];
}

class RefreshChallengeHabits extends ChallengeDetailEvent {
  const RefreshChallengeHabits(this.challengeId);

  final String challengeId;

  @override
  List<Object?> get props => [challengeId];
}

// ADD THIS EVENT
class UpdateChallengeHabitLog extends ChallengeDetailEvent {
  const UpdateChallengeHabitLog({
    required this.log,
    required this.status,
    this.completedValue,
  });

  final HabitLogEntity log;
  final LogStatus status;
  final int? completedValue;

  @override
  List<Object?> get props => [log, status, completedValue];
}