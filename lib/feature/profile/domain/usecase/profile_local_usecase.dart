import 'package:dartz/dartz.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/domain/entity/achievement_entity.dart';
import 'package:routiner/feature/profile/domain/repo/profile_local_repo.dart';

class ProfileLocalUseCase {
  ProfileLocalUseCase({required this.profileLocalRepo});

  final ProfileLocalRepo profileLocalRepo;

  UserEntity? getCachedProfile() => profileLocalRepo.getCachedProfile();

  Future<Unit> cacheProfile(final UserEntity profile) =>
      profileLocalRepo.cacheProfile(profile);

  Future<Unit> clearCachedProfile() => profileLocalRepo.clearCachedProfile();

  Future<List<ActivityEntity>> getActivities({final int? limit}) =>
      profileLocalRepo.getActivities(limit: limit);

  Future<int> getTotalPoints() => profileLocalRepo.getTotalPoints();

  /// Cache total points locally
  Future<Unit> cacheTotalPoints(final int points) =>
      profileLocalRepo.cacheTotalPoints(points);

  Future<List<AchievementEntity>> getAchievements() =>
      profileLocalRepo.getAchievements();

  Future<Unit> saveAchievements(final List<AchievementEntity> achievements) =>
      profileLocalRepo.saveAchievements(achievements);

  Future<Unit> updateAchievement(final AchievementEntity achievement) =>
      profileLocalRepo.updateAchievement(achievement);

  Future<Unit> clearAchievements() => profileLocalRepo.clearAchievements();

  UserEntity? getCurrentUser() =>
      profileLocalRepo.getCurrentUser();
}