import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/profile/domain/usecase/friends_remote_usecase.dart';

part 'friend_remote_event.dart';

part 'friend_remote_state.dart';

class FriendsRemoteBloc extends Bloc<FriendsRemoteEvent, FriendsRemoteState> {
  FriendsRemoteBloc({required this.friendUseCase})
    : super(const FriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<SearchUsers>(_onSearchUsers);
    on<AddFriend>(_onAddFriend);
    on<RemoveFriend>(_onRemoveFriend);
    on<ClearSearch>(_onClearSearch);
  }

  final FriendsRemoteUsecase friendUseCase;

  Future<void> _onLoadFriends(
    final LoadFriends event,
    final Emitter<FriendsRemoteState> emit,
  ) async {
    emit(const FriendsLoading());

    final Either<Failure, List<String>> idsResult = await friendUseCase
        .getFriendIds();

    await idsResult.fold(
      (final Failure failure) async {
        emit(FriendsError(message: failure.message));
      },
      (final List<String> friendIds) async {
        if (friendIds.isEmpty) {
          emit(const FriendsLoaded(friends: <UserEntity>[]));
          return;
        }

        final List<UserEntity> friends = <UserEntity>[];

        for (final String friendId in friendIds) {
          final Either<Failure, UserEntity> userResult = await friendUseCase
              .getUserById(friendId);

          userResult.fold((_) {}, friends.add);
        }

        emit(FriendsLoaded(friends: friends));
      },
    );
  }

  Future<void> _onSearchUsers(
    final SearchUsers event,
    final Emitter<FriendsRemoteState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const SearchCleared());
      return;
    }

    emit(const SearchLoading());

    final Either<Failure, List<UserEntity>> result = await friendUseCase
        .searchUsers(event.query);

    result.fold(
      (final Failure failure) {
        emit(SearchError(message: failure.message));
      },
      (final List<UserEntity> users) {
        emit(SearchLoaded(searchResults: users));
      },
    );
  }

  Future<void> _onAddFriend(
    final AddFriend event,
    final Emitter<FriendsRemoteState> emit,
  ) async {
    final FriendsRemoteState currentState = state;

    emit(const FriendActionLoading());

    final Either<Failure, Unit> result = await friendUseCase.addFriend(
      event.friendId,
    );

    await result.fold(
      (final Failure failure) async {
        emit(FriendActionError(message: failure.message));
        emit(currentState);
      },
      (_) async {
        emit(const FriendAdded());
        add(LoadFriends());
      },
    );
  }

  Future<void> _onRemoveFriend(
    final RemoveFriend event,
    final Emitter<FriendsRemoteState> emit,
  ) async {
    final FriendsRemoteState currentState = state;

    emit(const FriendActionLoading());

    final Either<Failure, Unit> result = await friendUseCase.removeFriend(
      event.friendId,
    );

    await result.fold(
      (final Failure failure) async {
        emit(FriendActionError(message: failure.message));
        emit(currentState);
      },
      (_) async {
        emit(const FriendRemoved());
        add(LoadFriends());
      },
    );
  }

  Future<void> _onClearSearch(
    final ClearSearch event,
    final Emitter<FriendsRemoteState> emit,
  ) async {
    emit(const SearchCleared());
    add(LoadFriends());

  }
}
