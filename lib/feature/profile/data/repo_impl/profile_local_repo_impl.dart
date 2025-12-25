import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_hive_model.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/data/data_source/local_data_sources/profile_display_local_data_source.dart';
import 'package:routiner/feature/profile/data/model/achievement_hive_model.dart';
import 'package:routiner/feature/profile/domain/entity/achievement_entity.dart';
import 'package:routiner/feature/profile/domain/repo/profile_local_repo.dart';

class ProfileLocalRepoImpl implements ProfileLocalRepo {
  ProfileLocalRepoImpl({required this.profileLocalDataSource});

  final ProfileLocalDataSource profileLocalDataSource;

  @override
  UserEntity? getCachedProfile() {
    final UserModel? userModel = profileLocalDataSource.getCachedProfile();
    return userModel;
  }

  @override
  Future<Unit> cacheProfile(final UserEntity profile) async {
    final UserModel userModel = UserModel(
      uid: profile.uid,
      email: profile.email,
      name: profile.name,
      surname: profile.surname,
      birthdate: profile.birthdate,
    );
    return profileLocalDataSource.cacheProfile(userModel);
  }

  @override
  Future<Unit> clearCachedProfile() {
    return profileLocalDataSource.clearCachedProfile();
  }

  @override
  Future<List<ActivityEntity>> getActivities({final int? limit}) async {
    final List<ActivityHiveModel> hiveModels = await profileLocalDataSource
        .getActivities(limit: limit);
    return hiveModels
        .map((final ActivityHiveModel model) => model.toEntity())
        .toList();
  }

  @override
  Future<int> getTotalPoints() {
    return profileLocalDataSource.getTotalPoints();
  }

  @override
  Future<Unit> cacheTotalPoints(final int points) {
    return profileLocalDataSource.cacheTotalPoints(points);
  }

  @override
  Future<List<AchievementEntity>> getAchievements() async {
    final List<AchievementHiveModel> hiveModels = await profileLocalDataSource
        .getAchievements();
    return hiveModels
        .map((final AchievementHiveModel model) => model.toEntity())
        .toList();
  }

  @override
  Future<Unit> saveAchievements(
      final List<AchievementEntity> achievements,
      ) async {
    final List<AchievementHiveModel> hiveModels = achievements
        .map(AchievementHiveModel.fromEntity)
        .toList();
    return profileLocalDataSource.saveAchievements(hiveModels);
  }

  @override
  Future<Unit> updateAchievement(final AchievementEntity achievement) async {
    final AchievementHiveModel hiveModel = AchievementHiveModel.fromEntity(
      achievement,
    );
    return profileLocalDataSource.updateAchievement(hiveModel);
  }

  @override
  Future<Unit> clearAchievements() {
    return profileLocalDataSource.clearAchievements();
  }

  @override
  UserEntity? getCurrentUser() {
    return profileLocalDataSource.getSavedUserCredentials();
  }
}