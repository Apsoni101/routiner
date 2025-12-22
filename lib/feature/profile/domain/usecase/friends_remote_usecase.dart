import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/profile/domain/repo/friend_remote_repo.dart';

/// Use case for friend operations
class FriendsRemoteUsecase {
  /// Creates an instance of FriendUseCase
  FriendsRemoteUsecase({required this.friendRemoteRepo});

  final FriendRemoteRepo friendRemoteRepo;

  /// Search for users
  Future<Either<Failure, List<UserEntity>>> searchUsers(final String query) =>
      friendRemoteRepo.searchUsers(query);

  /// Add a friend
  Future<Either<Failure, Unit>> addFriend(final String friendId) =>
      friendRemoteRepo.addFriend(friendId);

  /// Remove a friend
  Future<Either<Failure, Unit>> removeFriend(final String friendId) =>
      friendRemoteRepo.removeFriend(friendId);

  /// Get friend IDs
  Future<Either<Failure, List<String>>> getFriendIds() =>
      friendRemoteRepo.getFriendIds();

  /// Get user by ID
  Future<Either<Failure, UserEntity>> getUserById(final String userId) =>
      friendRemoteRepo.getUserById(userId);
}
