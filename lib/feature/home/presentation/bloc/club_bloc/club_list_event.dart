part of 'club_list_bloc.dart';

@immutable
sealed class ClubListEvent extends Equatable {
  const ClubListEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadClubsEvent extends ClubListEvent {}

/// Load current user ID
class LoadCurrentUserIdEvent extends ClubListEvent {}

/// Create club event
class CreateClubEvent extends ClubListEvent {
  const CreateClubEvent({
    required this.name,
    required this.description,
    this.imageUrl,
  });

  final String name;
  final String description;
  final String? imageUrl;

  @override
  List<Object?> get props => <Object?>[name, description, imageUrl];
}

/// Request to join club event
class RequestToJoinClubEvent extends ClubListEvent {
  const RequestToJoinClubEvent(this.clubId);

  final String clubId;

  @override
  List<Object?> get props => <Object?>[clubId];
}
class LoadCurrentUserEvent extends ClubListEvent {}

/// Accept join request event
class AcceptJoinRequestEvent extends ClubListEvent {
  const AcceptJoinRequestEvent({required this.clubId, required this.userId});

  final String clubId;
  final String userId;

  @override
  List<Object?> get props => <Object?>[clubId, userId];
}

/// Reject join request event
class RejectJoinRequestEvent extends ClubListEvent {
  const RejectJoinRequestEvent({required this.clubId, required this.userId});

  final String clubId;
  final String userId;

  @override
  List<Object?> get props => <Object?>[clubId, userId];
}

/// Add member event
class AddMemberEvent extends ClubListEvent {
  const AddMemberEvent({required this.clubId, required this.userId});

  final String clubId;
  final String userId;

  @override
  List<Object?> get props => <Object?>[clubId, userId];
}

/// Remove member event
class RemoveMemberEvent extends ClubListEvent {
  const RemoveMemberEvent({required this.clubId, required this.userId});

  final String clubId;
  final String userId;

  @override
  List<Object?> get props => <Object?>[clubId, userId];
}

/// Leave club event
class LeaveClubEvent extends ClubListEvent {
  const LeaveClubEvent(this.clubId);

  final String clubId;

  @override
  List<Object?> get props => <Object?>[clubId];
}
