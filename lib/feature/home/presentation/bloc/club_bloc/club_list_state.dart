part of 'club_list_bloc.dart';

@immutable
sealed class ClubListState extends Equatable {
  const ClubListState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial state
class ClubInitial extends ClubListState {}

/// Loading state
class ClubLoading extends ClubListState {}

/// Clubs loaded state

class ClubsLoaded extends ClubListState {
  final List<ClubEntity> allClubs;
  final List<ClubEntity> userClubs;
  final String currentUserId;

  const ClubsLoaded({
    required this.allClubs,
    required this.userClubs,
    required this.currentUserId,
  });

  @override
  List<Object?> get props => [allClubs, userClubs, currentUserId];
}


/// Club created state
class ClubCreated extends ClubListState {
  const ClubCreated(this.club);

  final ClubEntity club;

  @override
  List<Object?> get props => <Object?>[club];
}

/// Club action success state
class ClubActionSuccess extends ClubListState {
  const ClubActionSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Club error state
class ClubError extends ClubListState {
  const ClubError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
