import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/home/data/data_source/remote_data_source/club_remote_data_source.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';
import 'package:routiner/feature/home/domain/repo/club_remote_repo.dart';

/// Implementation of club repository
class ClubRepositoryImpl implements ClubRemoteRepository {
  ClubRepositoryImpl({required this.remoteDataSource});

  final ClubRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, String>> getCurrentUserId() {
    return remoteDataSource.getCurrentUserId();
  }

  @override
  Future<Either<Failure, ClubEntity>> createClub({
    required final String name,
    required final String description,
    final String? imageUrl,
  }) => remoteDataSource.createClub(
    name: name,
    description: description,
    imageUrl: imageUrl,
  );

  @override
  Future<Either<Failure, List<ClubEntity>>> getAllClubs() =>
      remoteDataSource.getAllClubs();

  @override
  Future<Either<Failure, List<ClubEntity>>> getUserClubs() =>
      remoteDataSource.getUserClubs();

  @override
  Future<Either<Failure, Unit>> requestToJoinClub(final String clubId) =>
      remoteDataSource.requestToJoinClub(clubId);

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

  @override
  Future<Either<Failure, Unit>> addMember(
    final String clubId,
    final String userId,
  ) => remoteDataSource.addMember(clubId, userId);

  @override
  Future<Either<Failure, Unit>> removeMember(
    final String clubId,
    final String userId,
  ) => remoteDataSource.removeMember(clubId, userId);

  @override
  Future<Either<Failure, ClubEntity>> getClubById(final String clubId) =>
      remoteDataSource.getClubById(clubId);

  @override
  Future<Either<Failure, Unit>> leaveClub(final String clubId) =>
      remoteDataSource.leaveClub(clubId);
}
