import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';

/// Abstract club repository
abstract class ClubRemoteRepository {
  /// Get current user ID
  Future<Either<Failure, String>> getCurrentUserId();

  /// Create a new club
  Future<Either<Failure, ClubEntity>> createClub({
    required final String name,
    required final String description,
    final String? imageUrl,
  });

  /// Get all clubs
  Future<Either<Failure, List<ClubEntity>>> getAllClubs();

  /// Get clubs user is a member of
  Future<Either<Failure, List<ClubEntity>>> getUserClubs();

  /// Request to join a club
  Future<Either<Failure, Unit>> requestToJoinClub(final String clubId);

  /// Accept join request (creator only)
  Future<Either<Failure, Unit>> acceptJoinRequest(
    final String clubId,
    final String userId,
  );

  /// Reject join request (creator only)
  Future<Either<Failure, Unit>> rejectJoinRequest(
    final String clubId,
    final String userId,
  );

  /// Add member to club (creator only)
  Future<Either<Failure, Unit>> addMember(
    final String clubId,
    final String userId,
  );

  /// Remove member from club (creator only)
  Future<Either<Failure, Unit>> removeMember(
    final String clubId,
    final String userId,
  );

  /// Get club by ID
  Future<Either<Failure, ClubEntity>> getClubById(final String clubId);

  /// Leave club
  Future<Either<Failure, Unit>> leaveClub(final String clubId);
}
