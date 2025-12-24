// domain/use_cases/profile_remote_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/domain/repo/profile_remote_repo.dart';

class ProfileRemoteUseCase {
  ProfileRemoteUseCase({required this.profileRemoteRepo});

  final ProfileRemoteRepo profileRemoteRepo;

  Future<Either<Failure, UserEntity>> getUserProfile(String uid) =>
      profileRemoteRepo.getUserProfile(uid);

  Future<Either<Failure, Unit>> updateUserProfile(UserEntity profile) =>
      profileRemoteRepo.updateUserProfile(profile);

  Future<Either<Failure, List<ActivityEntity>>> getActivities({int? limit}) =>
      profileRemoteRepo.getActivities(limit: limit);

  Future<Either<Failure, int>> getTotalPoints() =>
      profileRemoteRepo.getTotalPoints();
}