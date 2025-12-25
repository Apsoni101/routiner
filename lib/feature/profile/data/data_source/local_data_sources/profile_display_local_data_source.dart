import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_hive_model.dart';
import 'package:routiner/feature/profile/data/model/achievement_hive_model.dart';

abstract class ProfileLocalDataSource {
  UserModel? getCachedProfile();

  Future<Unit> cacheProfile(final UserModel profile);

  Future<Unit> clearCachedProfile();

  Future<List<ActivityHiveModel>> getActivities({final int? limit});

  Future<int> getTotalPoints();

  /// Cache total points to local storage
  Future<Unit> cacheTotalPoints(final int points);

  Future<List<AchievementHiveModel>> getAchievements();

  Future<Unit> saveAchievements(final List<AchievementHiveModel> achievements);

  Future<Unit> updateAchievement(final AchievementHiveModel achievement);

  Future<Unit> clearAchievements();

  UserModel? getSavedUserCredentials();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;
  static const String _profileKey = 'cached_profile';

  @override
  UserModel? getCachedProfile() {
    return _hiveService.getObject<UserModel>(_profileKey);
  }

  @override
  Future<Unit> cacheProfile(final UserModel profile) async {
    await _hiveService.setObject<UserModel>(_profileKey, profile);
    return unit;
  }

  @override
  Future<Unit> clearCachedProfile() async {
    await _hiveService.remove(_profileKey);
    return unit;
  }

  @override
  Future<List<ActivityHiveModel>> getActivities({final int? limit}) async {
    final List<ActivityHiveModel>? hiveModels = _hiveService
        .getObjectList<ActivityHiveModel>(HiveKeyConstants.activitiesListKey);

    if (hiveModels == null || hiveModels.isEmpty) {
      return <ActivityHiveModel>[];
    }

    List<ActivityHiveModel> activities =
    List<ActivityHiveModel>.from(hiveModels)
      ..sort((final ActivityHiveModel a, final ActivityHiveModel b) {
        final DateTime? aTime = a.timestamp != null
            ? DateTime.tryParse(a.timestamp!)
            : null;
        final DateTime? bTime = b.timestamp != null
            ? DateTime.tryParse(b.timestamp!)
            : null;
        if (aTime == null || bTime == null) {
          return 0;
        }
        return bTime.compareTo(aTime);
      });

    if (limit != null && activities.length > limit) {
      activities = activities.sublist(0, limit);
    }

    return activities;
  }

  @override
  Future<int> getTotalPoints() async {
    final int? points = _hiveService.getInt(HiveKeyConstants.totalPointsKey);
    return points ?? 0;
  }

  @override
  Future<Unit> cacheTotalPoints(final int points) async {
    await _hiveService.setInt(HiveKeyConstants.totalPointsKey, points);
    return unit;
  }

  static const String _achievementsKey = 'achievements_list';

  @override
  Future<List<AchievementHiveModel>> getAchievements() async {
    final List<AchievementHiveModel>? achievements = _hiveService
        .getObjectList<AchievementHiveModel>(_achievementsKey);
    return achievements ?? <AchievementHiveModel>[];
  }

  @override
  Future<Unit> saveAchievements(
      final List<AchievementHiveModel> achievements,
      ) async {
    await _hiveService.setObjectList(_achievementsKey, achievements);

    for (final AchievementHiveModel achievement in achievements) {
      await _hiveService.setObject(
        'achievement_${achievement.id}',
        achievement,
      );
    }

    return unit;
  }

  @override
  Future<Unit> updateAchievement(final AchievementHiveModel achievement) async {
    final List<AchievementHiveModel> achievements = await getAchievements();
    final int index = achievements.indexWhere(
          (final AchievementHiveModel a) => a.id == achievement.id,
    );

    if (index != -1) {
      achievements[index] = achievement;
      await saveAchievements(achievements);
    }

    return unit;
  }

  @override
  Future<Unit> clearAchievements() async {
    final List<AchievementHiveModel> achievements = await getAchievements();

    for (final AchievementHiveModel achievement in achievements) {
      await _hiveService.remove('achievement_${achievement.id}');
    }

    await _hiveService.remove(_achievementsKey);
    return unit;
  }

  @override
  UserModel? getSavedUserCredentials() {
    return _hiveService.getObject<UserModel>(HiveKeyConstants.userKey);
  }
}