part of 'friend_remote_bloc.dart';

@immutable
sealed class FriendsRemoteState extends Equatable {
  const FriendsRemoteState();

  @override
  List<Object?> get props => [];
}

final class FriendRemoteInitial extends FriendsRemoteState {
  const FriendRemoteInitial();
}

class FriendsInitial extends FriendsRemoteState {
  const FriendsInitial();
}

class FriendsLoading extends FriendsRemoteState {
  const FriendsLoading();
}

class FriendsLoaded extends FriendsRemoteState {
  const FriendsLoaded({required this.friends});

  final List<UserEntity> friends;

  @override
  List<Object?> get props => [friends];
}

class FriendsError extends FriendsRemoteState {
  const FriendsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class SearchLoading extends FriendsRemoteState {
  const SearchLoading();
}

class SearchLoaded extends FriendsRemoteState {
  const SearchLoaded({required this.searchResults});

  final List<UserEntity> searchResults;

  @override
  List<Object?> get props => [searchResults];
}

class SearchError extends FriendsRemoteState {
  const SearchError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class SearchCleared extends FriendsRemoteState {
  const SearchCleared();
}

class FriendActionLoading extends FriendsRemoteState {
  const FriendActionLoading();
}

class FriendAdded extends FriendsRemoteState {
  const FriendAdded();
}

class FriendRemoved extends FriendsRemoteState {
  const FriendRemoved();
}

class FriendActionError extends FriendsRemoteState {
  const FriendActionError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
