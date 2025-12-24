part of 'challenge_list_bloc.dart';

@immutable
sealed class ChallengesListEvent extends Equatable {
  const ChallengesListEvent();

  @override
  List<Object?> get props => <Object?>[];
}

final class LoadAllChallenges extends ChallengesListEvent {
  const LoadAllChallenges();
}

final class RefreshChallenges extends ChallengesListEvent {
  const RefreshChallenges({this.forceRemote = false});

  final bool forceRemote;

  @override
  List<Object?> get props => [forceRemote];
}
