import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/club_chat/data/data_source/remote/club_chat_remote_data_source.dart';
import 'package:routiner/feature/club_chat/domain/entity/club_message_entity.dart';
import 'package:routiner/feature/club_chat/domain/repo/club_chat_remote_repo.dart';

/// Implementation of club chat repository
class ClubChatRepositoryImpl implements ClubChatRemoteRepository {
  ClubChatRepositoryImpl({required this.remoteDataSource});

  final ClubChatRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required final String clubId,
    required final String message,
  }) => remoteDataSource.sendMessage(clubId: clubId, message: message);

  @override
  Stream<Either<Failure, List<ClubMessageEntity>>> getMessagesStream(
    final String clubId,
  ) => remoteDataSource.getMessagesStream(clubId);

  @override
  Future<Either<Failure, List<UserEntity>>> getClubMembers(
    final String clubId,
  ) => remoteDataSource.getClubMembers(clubId);

  @override
  Future<Either<Failure, List<UserEntity>>> getPendingRequests(
    final String clubId,
  ) => remoteDataSource.getPendingRequests(clubId);

  @override
  Future<Either<Failure, Unit>> acceptJoinRequest(
    final String clubId,
    final String userId,
  ) => remoteDataSource.acceptJoinRequest(clubId, userId);

  @override
  Future<Either<Failure, Unit>> rejectJoinRequest(
    final String clubId,
    final String userId,
  ) => remoteDataSource.rejectJoinRequest(clubId, userId);
}
