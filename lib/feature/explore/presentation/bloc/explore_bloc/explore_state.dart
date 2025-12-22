part of 'explore_bloc.dart';

@immutable
abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreClubsLoading extends ExploreState {}

class ExploreClubsLoaded extends ExploreState {
  const ExploreClubsLoaded({
    required this.clubs,
    required this.currentUserId,
    this.actionLoadingClubId,
    this.successMessage,
  });

  final List<ClubEntity> clubs;
  final String currentUserId;
  final String? actionLoadingClubId;
  final String? successMessage;

  @override
  List<Object?> get props => [
    clubs,
    currentUserId,
    actionLoadingClubId,
    successMessage,
  ];

  ExploreClubsLoaded copyWith({
    List<ClubEntity>? clubs,
    String? currentUserId,
    String? actionLoadingClubId,
    String? successMessage,
  }) {
    return ExploreClubsLoaded(
      clubs: clubs ?? this.clubs,
      currentUserId: currentUserId ?? this.currentUserId,
      actionLoadingClubId: actionLoadingClubId,
      successMessage: successMessage,
    );
  }
}

class ExploreClubsError extends ExploreState {
  const ExploreClubsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ❌ Remove this state - no longer needed
class ExploreClubActionSuccess extends ExploreState {
  const ExploreClubActionSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}