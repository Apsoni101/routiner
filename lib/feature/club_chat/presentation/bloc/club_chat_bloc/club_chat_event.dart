part of 'club_chat_bloc.dart';

@immutable
sealed class ClubChatEvent extends Equatable {
  const ClubChatEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Load messages for a club
class LoadMessagesEvent extends ClubChatEvent {
  const LoadMessagesEvent(this.clubId);

  final String clubId;

  @override
  List<Object?> get props => <Object?>[clubId];
}

/// Messages updated from stream
class MessagesUpdatedEvent extends ClubChatEvent {
  const MessagesUpdatedEvent(this.messages);

  final List<ClubMessageEntity> messages;

  @override
  List<Object?> get props => <Object?>[messages];
}

/// Send a message
class SendMessageEvent extends ClubChatEvent {
  const SendMessageEvent({required this.clubId, required this.message});

  final String clubId;
  final String message;

  @override
  List<Object?> get props => <Object?>[clubId, message];
}

/// Load club members
class LoadMembersEvent extends ClubChatEvent {
  const LoadMembersEvent(this.clubId);

  final String clubId;

  @override
  List<Object?> get props => <Object?>[clubId];
}

/// Load pending join requests
class LoadPendingRequestsEvent extends ClubChatEvent {
  const LoadPendingRequestsEvent(this.clubId);

  final String clubId;

  @override
  List<Object?> get props => <Object?>[clubId];
}

/// Accept join request
class AcceptJoinRequestEvent extends ClubChatEvent {
  const AcceptJoinRequestEvent({required this.clubId, required this.userId});

  final String clubId;
  final String userId;

  @override
  List<Object?> get props => <Object?>[clubId, userId];
}

/// Reject join request
class RejectJoinRequestEvent extends ClubChatEvent {
  const RejectJoinRequestEvent({required this.clubId, required this.userId});

  final String clubId;
  final String userId;

  @override
  List<Object?> get props => <Object?>[clubId, userId];
}
