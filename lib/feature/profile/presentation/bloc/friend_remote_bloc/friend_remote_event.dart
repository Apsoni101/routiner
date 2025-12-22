part of 'friend_remote_bloc.dart';

@immutable
sealed class FriendsRemoteEvent extends Equatable {
  const FriendsRemoteEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load friends list
class LoadFriends extends FriendsRemoteEvent {}

/// Event to search for users
class SearchUsers extends FriendsRemoteEvent {
  const SearchUsers({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to add a friend
class AddFriend extends FriendsRemoteEvent {
  const AddFriend({required this.friendId});

  final String friendId;

  @override
  List<Object?> get props => [friendId];
}

/// Event to remove a friend
class RemoveFriend extends FriendsRemoteEvent {
  const RemoveFriend({required this.friendId});

  final String friendId;

  @override
  List<Object?> get props => [friendId];
}

/// Event to clear search results
class ClearSearch extends FriendsRemoteEvent {}
