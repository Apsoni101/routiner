import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/profile/data/data_source/remote_data_sources/friend_remote_data_source.dart';
import 'package:routiner/feature/profile/domain/repo/friend_remote_repo.dart';

/// Implementation of FriendRemoteRepo
class FriendRemoteRepoImpl implements FriendRemoteRepo {
  /// Creates an instance of FriendRemoteRepoImpl
  FriendRemoteRepoImpl({required this.friendRemoteDataSource});

  final FriendRemoteDataSource friendRemoteDataSource;

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(
    final String query,
  ) async {
    final Either<Failure, List<UserModel>> result = await friendRemoteDataSource
        .searchUsers(query);

    return result.fold(
      Left.new,
      (final List<UserModel> models) => Right(models.cast<UserEntity>()),
    );
  }

  @override
  Future<Either<Failure, Unit>> addFriend(final String friendId) async {
    return friendRemoteDataSource.addFriend(friendId);
  }

  @override
  Future<Either<Failure, Unit>> removeFriend(final String friendId) async {
    return friendRemoteDataSource.removeFriend(friendId);
  }

  @override
  Future<Either<Failure, List<String>>> getFriendIds(
  ) async {
    return friendRemoteDataSource.getFriendIds();
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(final String userId) async {
    final Either<Failure, UserModel> result = await friendRemoteDataSource
        .getUserById(userId);

    return result.fold(Left.new, Right<Failure, UserEntity>.new);
  }
}
