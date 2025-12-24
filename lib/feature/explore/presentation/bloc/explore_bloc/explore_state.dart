part of 'explore_bloc.dart';

@immutable
abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  const ExploreLoaded({
    this.clubs,
    this.currentUserId,
    this.challenges,
    this.clubsError,
    this.challengesError,
    this.actionLoadingClubId,
    this.successMessage,
  });

  final List<ClubEntity>? clubs;
  final String? currentUserId;
  final List<ChallengeEntity>? challenges;
  final String? clubsError;
  final String? challengesError;
  final String? actionLoadingClubId;
  final String? successMessage;

  @override
  List<Object?> get props => [
    clubs,
    currentUserId,
    challenges,
    clubsError,
    challengesError,
    actionLoadingClubId,
    successMessage,
  ];

  ExploreLoaded copyWith({
    List<ClubEntity>? clubs,
    String? currentUserId,
    List<ChallengeEntity>? challenges,
    String? clubsError,
    String? challengesError,
    String? actionLoadingClubId,
    String? successMessage,
  }) {
    return ExploreLoaded(
      clubs: clubs ?? this.clubs,
      currentUserId: currentUserId ?? this.currentUserId,
      challenges: challenges ?? this.challenges,
      clubsError: clubsError ?? this.clubsError,
      challengesError: challengesError ?? this.challengesError,
      actionLoadingClubId: actionLoadingClubId,
      successMessage: successMessage,
    );
  }
}