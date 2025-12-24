import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/data/model/challenge_model.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/explore/data/data_source/remote/explore_remote_data_source.dart';
import 'package:routiner/feature/explore/domain/repo/explore_remote_repo.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';

/// Implementation of club repository
class ExploreRemoteRepositoryImpl implements ExploreRemoteRepository {
  ExploreRemoteRepositoryImpl({required this.remoteDataSource});

  final ExploreRemoteDataSource remoteDataSource;

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

  @override
  Future<Either<Failure, List<ChallengeEntity>>> getAllChallenges() async {
    final Either<Failure, List<ChallengeModel>> result =
    await remoteDataSource.getAllChallenges();

    return result.fold(
      Left.new,
          (final List<ChallengeModel> models) =>
          Right(models.map((final ChallengeModel m) => m.toEntity()).toList()),
    );
  }
}
