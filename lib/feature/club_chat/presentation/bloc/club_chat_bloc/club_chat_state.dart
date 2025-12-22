part of 'club_chat_bloc.dart';

@immutable
sealed class ClubChatState extends Equatable {
  const ClubChatState();

  @override
  List<Object?> get props => <Object?>[];
}

final class ClubChatInitial extends ClubChatState {}

final class ClubChatLoaded extends ClubChatState {
  const ClubChatLoaded({
    this.messages = const <ClubMessageEntity>[],
    this.members = const <UserEntity>[],
    this.pendingUsers = const <UserEntity>[],
    this.isLoadingMessages = false,
    this.isLoadingMembers = false,
    this.isLoadingRequests = false,
    this.errorMessage,
    this.successMessage,
  });

  final List<ClubMessageEntity> messages;
  final List<UserEntity> members;
  final List<UserEntity> pendingUsers;
  final bool isLoadingMessages;
  final bool isLoadingMembers;
  final bool isLoadingRequests;
  final String? errorMessage;
  final String? successMessage;

  @override
  List<Object?> get props => <Object?>[
    messages,
    members,
    pendingUsers,
    isLoadingMessages,
    isLoadingMembers,
    isLoadingRequests,
    errorMessage,
    successMessage,
  ];

  ClubChatLoaded copyWith({
    final List<ClubMessageEntity>? messages,
    final List<UserEntity>? members,
    final List<UserEntity>? pendingUsers,
    final bool? isLoadingMessages,
    final bool? isLoadingMembers,
    final bool? isLoadingRequests,
    final String? errorMessage,
    final String? successMessage,
    final bool clearError = false,
    final bool clearSuccess = false,
  }) {
    return ClubChatLoaded(
      messages: messages ?? this.messages,
      members: members ?? this.members,
      pendingUsers: pendingUsers ?? this.pendingUsers,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isLoadingMembers: isLoadingMembers ?? this.isLoadingMembers,
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}
