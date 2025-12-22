import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/club_chat/domain/entity/club_message_entity.dart';
import 'package:routiner/feature/club_chat/domain/repo/club_chat_remote_repo.dart';

class ClubChatRemoteUseCase {
  ClubChatRemoteUseCase(this.repository);

  final ClubChatRemoteRepository repository;

  /// Send a message
  Future<Either<Failure, Unit>> sendMessage({
    required final String clubId,
    required final String message,
  }) {
    return repository.sendMessage(clubId: clubId, message: message);
  }

  /// Listen to messages stream
  Stream<Either<Failure, List<ClubMessageEntity>>> getMessagesStream(
    final String clubId,
  ) {
    return repository.getMessagesStream(clubId);
  }

  /// Get club members
  Future<Either<Failure, List<UserEntity>>> getClubMembers(
    final String clubId,
  ) {
    return repository.getClubMembers(clubId);
  }

  Future<Either<Failure, List<UserEntity>>> getPendingRequests(
    final String clubId,
  ) async {
    return repository.getPendingRequests(clubId);
  }

  /// Accept join request
  Future<Either<Failure, Unit>> acceptJoinRequest(
    final String clubId,
    final String userId,
  ) async {
    return repository.acceptJoinRequest(clubId, userId);
  }

  /// Reject join request
  Future<Either<Failure, Unit>> rejectJoinRequest(
    final String clubId,
    final String userId,
  ) async {
    return repository.rejectJoinRequest(clubId, userId);
  }
}
