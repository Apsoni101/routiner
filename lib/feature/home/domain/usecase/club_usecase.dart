import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';
import 'package:routiner/feature/home/domain/repo/club_remote_repo.dart';

class ClubRemoteUseCase {
  ClubRemoteUseCase(this.repository);

  final ClubRemoteRepository repository;

  /// Get current user ID
  Future<Either<Failure, String>> getCurrentUserId() {
    return repository.getCurrentUserId();
  }

  /// Create club
  Future<Either<Failure, ClubEntity>> createClub({
    required final String name,
    required final String description,
    final String? imageUrl,
  }) {
    return repository.createClub(
      name: name,
      description: description,
      imageUrl: imageUrl,
    );
  }

  /// Get all clubs
  Future<Either<Failure, List<ClubEntity>>> getAllClubs() {
    return repository.getAllClubs();
  }

  /// Get clubs of current user
  Future<Either<Failure, List<ClubEntity>>> getUserClubs() {
    return repository.getUserClubs();
  }

  /// Request to join a club
  Future<Either<Failure, Unit>> requestToJoinClub(final String clubId) {
    return repository.requestToJoinClub(clubId);
  }

  /// Accept join request
  Future<Either<Failure, Unit>> acceptJoinRequest(
    final String clubId,
    final String userId,
  ) {
    return repository.acceptJoinRequest(clubId, userId);
  }

  /// Reject join request
  Future<Either<Failure, Unit>> rejectJoinRequest(
    final String clubId,
    final String userId,
  ) {
    return repository.rejectJoinRequest(clubId, userId);
  }

  /// Add member
  Future<Either<Failure, Unit>> addMember(
    final String clubId,
    final String userId,
  ) {
    return repository.addMember(clubId, userId);
  }

  /// Remove member
  Future<Either<Failure, Unit>> removeMember(
    final String clubId,
    final String userId,
  ) {
    return repository.removeMember(clubId, userId);
  }

  /// Get club by ID
  Future<Either<Failure, ClubEntity>> getClubById(final String clubId) {
    return repository.getClubById(clubId);
  }

  /// Leave club
  Future<Either<Failure, Unit>> leaveClub(final String clubId) {
    return repository.leaveClub(clubId);
  }
}
