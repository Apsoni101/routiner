// data/data_sources/profile_local_data_source.dart
import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_hive_model.dart';

abstract class ProfileLocalDataSource {
  UserModel? getCachedProfile();
  Future<Unit> cacheProfile(final UserModel profile);
  Future<Unit> clearCachedProfile();
  Future<List<ActivityHiveModel>> getActivities({int? limit});
  Future<int> getTotalPoints();
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
  Future<List<ActivityHiveModel>> getActivities({int? limit}) async {
    final List<ActivityHiveModel>? hiveModels =
    _hiveService.getObjectList<ActivityHiveModel>(
      HiveKeyConstants.activitiesListKey,
    );

    if (hiveModels == null || hiveModels.isEmpty) {
      return <ActivityHiveModel>[];
    }

    var activities = List<ActivityHiveModel>.from(hiveModels)

    // Sort by timestamp descending (newest first)
    ..sort((a, b) {
      final aTime = a.timestamp != null ? DateTime.tryParse(a.timestamp!) : null;
      final bTime = b.timestamp != null ? DateTime.tryParse(b.timestamp!) : null;
      if (aTime == null || bTime == null) return 0;
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
}