import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_hive_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_hive_model.dart';
import 'package:routiner/feature/home/data/model/habit_log_hive_model.dart';

abstract class HabitDisplayLocalDataSource {
  // Habit Log Methods
  Future<void> saveLog(final HabitLogHiveModel log);

  Future<List<HabitLogHiveModel>> getAllLogs();

  Future<void> updateLogsList(final List<HabitLogHiveModel> logs);

  Future<void> saveLogById(final String id, final HabitLogHiveModel log);

  Future<List<CustomHabitHiveModel>> getCustomHabits();

  Future<void> saveFriendsCount(final String habitId, final int count);

  Future<int?> getFriendsCount(final String habitId);

  Future<Map<String, int>> getAllFriendsCounts();

  Future<void> clearFriendsCount(final String habitId);

  Future<void> saveActivity(final ActivityHiveModel activity);
  Future<List<ActivityHiveModel>> getActivities({int? limit});
  Future<int> getTotalPoints();
  Future<void> updateTotalPoints(int points);
}

class HabitDisplayLocalDataSourceImpl implements HabitDisplayLocalDataSource {
  HabitDisplayLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  @override
  Future<void> saveLog(final HabitLogHiveModel log) async {
    await _hiveService.setObject('${HiveKeyConstants.logsKey}_${log.id}', log);
  }

  @override
  Future<List<HabitLogHiveModel>> getAllLogs() async {
    return _hiveService.getObjectList<HabitLogHiveModel>(
          HiveKeyConstants.logsListKey,
        ) ??
        <HabitLogHiveModel>[];
  }

  @override
  Future<void> updateLogsList(final List<HabitLogHiveModel> logs) async {
    await _hiveService.setObjectList(HiveKeyConstants.logsListKey, logs);
  }

  @override
  Future<void> saveLogById(final String id, final HabitLogHiveModel log) async {
    await _hiveService.setObject('${HiveKeyConstants.logsKey}_$id', log);
  }

  @override
  Future<List<CustomHabitHiveModel>> getCustomHabits() async {
    return _hiveService.getObjectList<CustomHabitHiveModel>(
          HiveKeyConstants.customHabitsListKey,
        ) ??
        <CustomHabitHiveModel>[];
  }

  // Friends Count Implementation
  @override
  Future<void> saveFriendsCount(final String habitId, final int count) async {
    // Get current map
    final Map<String, int> currentMap = await getAllFriendsCounts();

    // Update the map
    currentMap[habitId] = count;

    // Save both individual key and the map
    await _hiveService.setObject(
      '${HiveKeyConstants.friendsCountKey}_$habitId',
      count,
    );

    // Save the entire map for quick retrieval
    await _hiveService.setObject(
      HiveKeyConstants.friendsCountMapKey,
      currentMap,
    );
  }

  @override
  Future<int?> getFriendsCount(final String habitId) async {
    // Try to get from individual key first
    final int? individualCount = _hiveService.getObject<int>(
      '${HiveKeyConstants.friendsCountKey}_$habitId',
    );

    if (individualCount != null) {
      return individualCount;
    }

    // Fallback to map
    final Map<String, int> countsMap = await getAllFriendsCounts();
    return countsMap[habitId];
  }

  @override
  Future<Map<String, int>> getAllFriendsCounts() async {
    final dynamic rawMap = _hiveService.getObject<dynamic>(
      HiveKeyConstants.friendsCountMapKey,
    );

    if (rawMap == null) {
      return <String, int>{};
    }

    // Handle different map types
    if (rawMap is Map<String, int>) {
      return Map<String, int>.from(rawMap);
    } else if (rawMap is Map) {
      return Map<String, int>.from(
        rawMap.map(
          (key, value) => MapEntry(key.toString(), value is int ? value : 0),
        ),
      );
    }

    return <String, int>{};
  }

  @override
  Future<void> clearFriendsCount(final String habitId) async {
    // Remove from individual key
    await _hiveService.deleteObject(
      '${HiveKeyConstants.friendsCountKey}_$habitId',
    );

    // Remove from map
    final Map<String, int> currentMap = await getAllFriendsCounts();
    currentMap.remove(habitId);
    await _hiveService.setObject(
      HiveKeyConstants.friendsCountMapKey,
      currentMap,
    );
  }

  @override
  Future<void> saveActivity(final ActivityHiveModel activity) async {
    final List<ActivityHiveModel> existingActivities =
        _hiveService.getObjectList<ActivityHiveModel>(
          HiveKeyConstants.activitiesListKey,
        ) ?? <ActivityHiveModel>[]
          ..add(activity);

    await _hiveService.setObjectList(
      HiveKeyConstants.activitiesListKey,
      existingActivities,
    );

    await _hiveService.setObject(
      '${HiveKeyConstants.activityKey}_${activity.id}',
      activity,
    );

    // Update total points
    final currentPoints = await getTotalPoints();
    await updateTotalPoints(currentPoints + (activity.points ?? 0));
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

  @override
  Future<void> updateTotalPoints(int points) async {
    await _hiveService.setInt(HiveKeyConstants.totalPointsKey, points);
  }

}
