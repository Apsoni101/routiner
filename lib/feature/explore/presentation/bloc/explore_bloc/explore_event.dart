part of 'explore_bloc.dart';

@immutable
abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

class LoadExploreClubsEvent extends ExploreEvent {}

class RequestToJoinClubFromExploreEvent extends ExploreEvent {
  const RequestToJoinClubFromExploreEvent(this.clubId);

  final String clubId;

  @override
  List<Object?> get props => [clubId];
}

class RemoveMemberFromExploreEvent extends ExploreEvent {
  const RemoveMemberFromExploreEvent({
    required this.clubId,
    required this.userId,
  });

  final String clubId;
  final String userId;

  @override
  List<Object?> get props => [clubId, userId];
}

class LeaveClubFromExploreEvent extends ExploreEvent {
  const LeaveClubFromExploreEvent(this.clubId);

  final String clubId;

  @override
  List<Object?> get props => [clubId];
}