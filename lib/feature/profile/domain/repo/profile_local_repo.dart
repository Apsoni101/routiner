import 'package:dartz/dartz.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/domain/entity/achievement_entity.dart';

abstract class ProfileLocalRepo {
  UserEntity? getCachedProfile();

  Future<Unit> cacheProfile(final UserEntity profile);

  Future<Unit> clearCachedProfile();

  Future<List<ActivityEntity>> getActivities({final int? limit});

  Future<int> getTotalPoints();

  /// Cache total points to local storage
  Future<Unit> cacheTotalPoints(final int points);

  Future<List<AchievementEntity>> getAchievements();

  Future<Unit> saveAchievements(final List<AchievementEntity> achievements);

  Future<Unit> updateAchievement(final AchievementEntity achievement);

  Future<Unit> clearAchievements();

  UserEntity? getCurrentUser();
}