import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';

/// Abstract repository for remote friend operations
abstract class FriendRemoteRepo {
  /// Search for users by query string
  Future<Either<Failure, List<UserEntity>>> searchUsers(final String query);

  /// Add a friend for the current user
  Future<Either<Failure, Unit>> addFriend(
    final String friendId,
  );

  /// Remove a friend for the current user
  Future<Either<Failure, Unit>> removeFriend(
    final String friendId,
  );

  /// Get all friend IDs for a user
  Future<Either<Failure, List<String>>> getFriendIds();

  /// Get user details by ID
  Future<Either<Failure, UserEntity>> getUserById(final String userId);
}
