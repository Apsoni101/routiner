// lib/feature/challenge/data/data_source/local/challenge_local_data_source.dart

import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/feature/challenge/data/model/challenge_hive_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_hive_model.dart';
import 'package:routiner/feature/home/data/model/habit_log_hive_model.dart';

abstract class ChallengeLocalDataSource {
  // Challenge CRUD Methods
  Future<void> saveChallenge(final ChallengeHiveModel challenge);

  Future<ChallengeHiveModel?> getChallengeById(final String challengeId);

  Future<List<ChallengeHiveModel>> getAllChallenges();

  Future<void> updateChallengesList(final List<ChallengeHiveModel> challenges);

  Future<void> deleteChallenge(final String challengeId);

  // Challenge Progress Cache
  Future<void> saveChallengeProgress({
    required final String challengeId,
    required final int totalGoalValue,
    required final int completedValue,
  });

  Future<Map<String, dynamic>?> getChallengeProgress(final String challengeId);

  Future<void> clearChallengeProgress(final String challengeId);

  // Participant IDs Cache
  Future<void> saveParticipantIds({
    required final String challengeId,
    required final List<String> participantIds,
  });

  Future<List<String>?> getParticipantIds(final String challengeId);

  // Last Sync Timestamp
  Future<void> saveLastSyncTime(final DateTime syncTime);

  Future<DateTime?> getLastSyncTime();

  // Habit Methods (for challenge-related habit operations)
  Future<void> saveHabit(final CustomHabitHiveModel habit);

  Future<CustomHabitHiveModel?> getHabitById(final String habitId);

  Future<List<CustomHabitHiveModel>> getAllHabits();

  Future<void> updateHabitsList(final List<CustomHabitHiveModel> habits);

  // Habit Log Methods (for challenge habit logs)
  Future<void> saveHabitLog(final HabitLogHiveModel log);

  Future<HabitLogHiveModel?> getHabitLogById(final String logId);

  Future<List<HabitLogHiveModel>> getAllHabitLogs();

  Future<void> updateHabitLogsList(final List<HabitLogHiveModel> logs);

  // Friends Count Cache (for challenge habits)
  Future<void> saveFriendsCount(final String habitId, final int count);

  Future<int?> getFriendsCount(final String habitId);

  Future<Map<String, int>> getAllFriendsCounts();

  Future<void> clearFriendsCount(final String habitId);
}

class ChallengeLocalDataSourceImpl implements ChallengeLocalDataSource {
  ChallengeLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  @override
  Future<void> saveChallenge(final ChallengeHiveModel challenge) async {
    if (challenge.id == null || challenge.id!.isEmpty) {
      return;
    }

    await _hiveService.setObject(
      '${HiveKeyConstants.challengeKey}_${challenge.id}',
      challenge,
    );

    // Update challenges list
    final List<ChallengeHiveModel> challenges = await getAllChallenges();
    final int index = challenges.indexWhere(
          (final c) => c.id == challenge.id,
    );

    if (index != -1) {
      challenges[index] = challenge;
    } else {
      challenges.add(challenge);
    }

    await updateChallengesList(challenges);
  }

  @override
  Future<ChallengeHiveModel?> getChallengeById(final String challengeId) async {
    return _hiveService.getObject<ChallengeHiveModel>(
      '${HiveKeyConstants.challengeKey}_$challengeId',
    );
  }

  @override
  Future<List<ChallengeHiveModel>> getAllChallenges() async {
    return _hiveService.getObjectList<ChallengeHiveModel>(
      HiveKeyConstants.challengesListKey,
    ) ??
        <ChallengeHiveModel>[];
  }

  @override
  Future<void> updateChallengesList(
      final List<ChallengeHiveModel> challenges,
      ) async {
    await _hiveService.setObjectList(
      HiveKeyConstants.challengesListKey,
      challenges,
    );
  }

  @override
  Future<void> deleteChallenge(final String challengeId) async {
    // Delete individual challenge
    await _hiveService.deleteObject(
      '${HiveKeyConstants.challengeKey}_$challengeId',
    );

    // Update challenges list
    final List<ChallengeHiveModel> challenges = await getAllChallenges();
    challenges.removeWhere((final c) => c.id == challengeId);
    await updateChallengesList(challenges);

    // Clear related cache
    await clearChallengeProgress(challengeId);
  }

  @override
  Future<void> saveChallengeProgress({
    required final String challengeId,
    required final int totalGoalValue,
    required final int completedValue,
  }) async {
    final Map<String, dynamic> progressData = {
      'totalGoalValue': totalGoalValue,
      'completedValue': completedValue,
      'lastUpdated': DateTime.now().toIso8601String(),
    };

    await _hiveService.setObject(
      '${HiveKeyConstants.challengeProgressKey}_$challengeId',
      progressData,
    );
  }

  @override
  Future<Map<String, dynamic>?> getChallengeProgress(
      final String challengeId,
      ) async {
    final dynamic rawData = _hiveService.getObject<dynamic>(
      '${HiveKeyConstants.challengeProgressKey}_$challengeId',
    );

    if (rawData == null) {
      return null;
    }

    if (rawData is Map<String, dynamic>) {
      return rawData;
    } else if (rawData is Map) {
      return Map<String, dynamic>.from(rawData);
    }

    return null;
  }

  @override
  Future<void> clearChallengeProgress(final String challengeId) async {
    await _hiveService.deleteObject(
      '${HiveKeyConstants.challengeProgressKey}_$challengeId',
    );
  }

  @override
  Future<void> saveParticipantIds({
    required final String challengeId,
    required final List<String> participantIds,
  }) async {
    await _hiveService.setObject(
      '${HiveKeyConstants.challengeParticipantsKey}_$challengeId',
      participantIds,
    );
  }

  @override
  Future<List<String>?> getParticipantIds(final String challengeId) async {
    final dynamic rawList = _hiveService.getObject<dynamic>(
      '${HiveKeyConstants.challengeParticipantsKey}_$challengeId',
    );

    if (rawList == null) {
      return null;
    }

    if (rawList is List<String>) {
      return rawList;
    } else if (rawList is List) {
      return rawList.map((e) => e.toString()).toList();
    }

    return null;
  }

  @override
  Future<void> saveLastSyncTime(final DateTime syncTime) async {
    await _hiveService.setObject(
      HiveKeyConstants.challengeLastSyncKey,
      syncTime.toIso8601String(),
    );
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    final String? timeString = _hiveService.getObject<String>(
      HiveKeyConstants.challengeLastSyncKey,
    );

    if (timeString == null) {
      return null;
    }

    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  // ============================================
  // Habit Methods
  // ============================================

  @override
  Future<void> saveHabit(final CustomHabitHiveModel habit) async {
    if (habit.id == null || habit.id!.isEmpty) {
      return;
    }

    await _hiveService.setObject(
      '${HiveKeyConstants.customHabitsKey}_${habit.id}',
      habit,
    );

    // Update habits list
    final List<CustomHabitHiveModel> habits = await getAllHabits();
    final int index = habits.indexWhere((final h) => h.id == habit.id);

    if (index != -1) {
      habits[index] = habit;
    } else {
      habits.add(habit);
    }

    await updateHabitsList(habits);
  }

  @override
  Future<CustomHabitHiveModel?> getHabitById(final String habitId) async {
    return _hiveService.getObject<CustomHabitHiveModel>(
      '${HiveKeyConstants.customHabitsKey}_$habitId',
    );
  }

  @override
  Future<List<CustomHabitHiveModel>> getAllHabits() async {
    return _hiveService.getObjectList<CustomHabitHiveModel>(
      HiveKeyConstants.customHabitsListKey,
    ) ??
        <CustomHabitHiveModel>[];
  }

  @override
  Future<void> updateHabitsList(final List<CustomHabitHiveModel> habits) async {
    await _hiveService.setObjectList(
      HiveKeyConstants.customHabitsListKey,
      habits,
    );
  }

  // ============================================
  // Habit Log Methods
  // ============================================

  @override
  Future<void> saveHabitLog(final HabitLogHiveModel log) async {
    if (log.id == null || log.id!.isEmpty) {
      return;
    }

    await _hiveService.setObject(
      '${HiveKeyConstants.logsKey}_${log.id}',
      log,
    );

    // Update logs list
    final List<HabitLogHiveModel> logs = await getAllHabitLogs();
    final int index = logs.indexWhere((final l) => l.id == log.id);

    if (index != -1) {
      logs[index] = log;
    } else {
      logs.add(log);
    }

    await updateHabitLogsList(logs);
  }

  @override
  Future<HabitLogHiveModel?> getHabitLogById(final String logId) async {
    return _hiveService.getObject<HabitLogHiveModel>(
      '${HiveKeyConstants.logsKey}_$logId',
    );
  }

  @override
  Future<List<HabitLogHiveModel>> getAllHabitLogs() async {
    return _hiveService.getObjectList<HabitLogHiveModel>(
      HiveKeyConstants.logsListKey,
    ) ??
        <HabitLogHiveModel>[];
  }

  @override
  Future<void> updateHabitLogsList(
      final List<HabitLogHiveModel> logs,
      ) async {
    await _hiveService.setObjectList(HiveKeyConstants.logsListKey, logs);
  }

  // ============================================
  // Friends Count Cache
  // ============================================

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
}