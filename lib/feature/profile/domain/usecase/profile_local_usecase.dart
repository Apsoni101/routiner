import 'package:dartz/dartz.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/domain/repo/profile_local_repo.dart';

class ProfileLocalUseCase {
  ProfileLocalUseCase({required this.profileLocalRepo});

  final ProfileLocalRepo profileLocalRepo;

  UserEntity? getCachedProfile() => profileLocalRepo.getCachedProfile();

  Future<Unit> cacheProfile(UserEntity profile) =>
      profileLocalRepo.cacheProfile(profile);

  Future<Unit> clearCachedProfile() => profileLocalRepo.clearCachedProfile();
  Future<List<ActivityEntity>> getActivities({int? limit}) =>
      profileLocalRepo.getActivities(limit: limit);

  Future<int> getTotalPoints() => profileLocalRepo.getTotalPoints();
}