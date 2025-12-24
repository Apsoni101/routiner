part of 'challenge_list_bloc.dart';

@immutable
sealed class ChallengesListState extends Equatable {
  const ChallengesListState();

  @override
  List<Object?> get props => <Object?>[];
}

final class ChallengesListInitial extends ChallengesListState {
  const ChallengesListInitial();
}

final class ChallengesListLoading extends ChallengesListState {
  const ChallengesListLoading();
}

final class ChallengesListLoaded extends ChallengesListState {
  const ChallengesListLoaded(this.challenges);

  final List<ChallengeEntity> challenges;

  @override
  List<Object?> get props => <Object?>[challenges];
}

final class ChallengesListError extends ChallengesListState {
  const ChallengesListError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
