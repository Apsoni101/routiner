import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/club_chat/domain/entity/club_message_entity.dart';

/// Abstract club chat remote repository
abstract class ClubChatRemoteRepository {
  /// Send a message to club chat
  Future<Either<Failure, Unit>> sendMessage({
    required final String clubId,
    required final String message,
  });

  /// Get messages stream for a club
  Stream<Either<Failure, List<ClubMessageEntity>>> getMessagesStream(
    final String clubId,
  );

  /// Get club members
  Future<Either<Failure, List<UserEntity>>> getClubMembers(final String clubId);

  /// Get pending join requests
  Future<Either<Failure, List<UserEntity>>> getPendingRequests(
    final String clubId,
  );

  /// Accept join request
  Future<Either<Failure, Unit>> acceptJoinRequest(
    final String clubId,
    final String userId,
  );

  /// Reject join request
  Future<Either<Failure, Unit>> rejectJoinRequest(
    final String clubId,
    final String userId,
  );
}
