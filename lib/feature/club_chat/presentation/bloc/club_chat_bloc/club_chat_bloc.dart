import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/club_chat/domain/entity/club_message_entity.dart';
import 'package:routiner/feature/club_chat/domain/usecase/club_chat_remote_usecase.dart';

part 'club_chat_event.dart';

part 'club_chat_state.dart';

/// Club chat BLoC
class ClubChatBloc extends Bloc<ClubChatEvent, ClubChatState> {
  ClubChatBloc({required this.clubChatUseCase}) : super(ClubChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<MessagesUpdatedEvent>(_onMessagesUpdated);
    on<SendMessageEvent>(_onSendMessage);
    on<LoadMembersEvent>(_onLoadMembers);
    on<LoadPendingRequestsEvent>(_onLoadPendingRequests);
    on<AcceptJoinRequestEvent>(_onAcceptJoinRequest);
    on<RejectJoinRequestEvent>(_onRejectJoinRequest);
  }

  final ClubChatRemoteUseCase clubChatUseCase;

  StreamSubscription? _messagesSubscription;

  ClubChatLoaded _getLoadedState() {
    if (state is ClubChatLoaded) {
      return state as ClubChatLoaded;
    }
    return const ClubChatLoaded();
  }

  /// Load messages stream
  Future<void> _onLoadMessages(
    final LoadMessagesEvent event,
    final Emitter<ClubChatState> emit,
  ) async {
    final ClubChatLoaded currentState = _getLoadedState();
    emit(currentState.copyWith(isLoadingMessages: true));

    await _messagesSubscription?.cancel();

    _messagesSubscription = clubChatUseCase
        .getMessagesStream(event.clubId)
        .listen(
          (final Either<Failure, List<ClubMessageEntity>> result) {
            result.fold(
              (final Failure failure) {
                add(const MessagesUpdatedEvent(<ClubMessageEntity>[]));
              },
              (final List<ClubMessageEntity> messages) {
                add(MessagesUpdatedEvent(messages));
              },
            );
          },
          onError: (final error) {
            add(const MessagesUpdatedEvent(<ClubMessageEntity>[]));
          },
        );
  }

  /// Update messages when stream emits
  Future<void> _onMessagesUpdated(
    final MessagesUpdatedEvent event,
    final Emitter<ClubChatState> emit,
  ) async {
    final ClubChatLoaded currentState = _getLoadedState();
    emit(
      currentState.copyWith(messages: event.messages, isLoadingMessages: false),
    );
  }

  /// Send message
  Future<void> _onSendMessage(
    final SendMessageEvent event,
    final Emitter<ClubChatState> emit,
  ) async {
    final Either<Failure, Unit> result = await clubChatUseCase.sendMessage(
      clubId: event.clubId,
      message: event.message,
    );

    result.fold(
      (final Failure failure) {
        final ClubChatLoaded currentState = _getLoadedState();
        emit(currentState.copyWith(errorMessage: failure.message));
      },
      (_) {
        // Message sent successfully, stream will update automatically
      },
    );
  }

  /// Load club members
  Future<void> _onLoadMembers(
    final LoadMembersEvent event,
    final Emitter<ClubChatState> emit,
  ) async {
    final ClubChatLoaded currentState = _getLoadedState();
    emit(currentState.copyWith(isLoadingMembers: true, clearError: true));

    final Either<Failure, List<UserEntity>> result = await clubChatUseCase
        .getClubMembers(event.clubId);

    result.fold(
      (final Failure failure) {
        final ClubChatLoaded state = _getLoadedState();
        emit(
          state.copyWith(
            isLoadingMembers: false,
            errorMessage: failure.message,
          ),
        );
      },
      (final List<UserEntity> members) {
        final ClubChatLoaded state = _getLoadedState();
        emit(state.copyWith(members: members, isLoadingMembers: false));
      },
    );
  }

  /// Load pending join requests
  Future<void> _onLoadPendingRequests(
    final LoadPendingRequestsEvent event,
    final Emitter<ClubChatState> emit,
  ) async {
    final ClubChatLoaded currentState = _getLoadedState();
    emit(currentState.copyWith(isLoadingRequests: true, clearError: true));

    final Either<Failure, List<UserEntity>> result = await clubChatUseCase
        .getPendingRequests(event.clubId);

    result.fold(
      (final Failure failure) {
        final ClubChatLoaded state = _getLoadedState();
        emit(
          state.copyWith(
            isLoadingRequests: false,
            errorMessage: failure.message,
          ),
        );
      },
      (final List<UserEntity> pendingUsers) {
        final ClubChatLoaded state = _getLoadedState();
        emit(
          state.copyWith(pendingUsers: pendingUsers, isLoadingRequests: false),
        );
      },
    );
  }

  /// Accept join request
  Future<void> _onAcceptJoinRequest(
    final AcceptJoinRequestEvent event,
    final Emitter<ClubChatState> emit,
  ) async {
    final Either<Failure, Unit> result = await clubChatUseCase
        .acceptJoinRequest(event.clubId, event.userId);

    result.fold(
      (final Failure failure) {
        final ClubChatLoaded currentState = _getLoadedState();
        emit(currentState.copyWith(errorMessage: failure.message));
      },
      (_) {
        final ClubChatLoaded currentState = _getLoadedState();
        emit(
          currentState.copyWith(
            successMessage: 'Request accepted',
            clearError: true,
          ),
        );
      },
    );
  }

  /// Reject join request
  Future<void> _onRejectJoinRequest(
    final RejectJoinRequestEvent event,
    final Emitter<ClubChatState> emit,
  ) async {
    final Either<Failure, Unit> result = await clubChatUseCase
        .rejectJoinRequest(event.clubId, event.userId);

    result.fold(
      (final Failure failure) {
        final ClubChatLoaded currentState = _getLoadedState();
        emit(currentState.copyWith(errorMessage: failure.message));
      },
      (_) {
        final ClubChatLoaded currentState = _getLoadedState();
        emit(
          currentState.copyWith(
            successMessage: 'Request rejected',
            clearError: true,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
