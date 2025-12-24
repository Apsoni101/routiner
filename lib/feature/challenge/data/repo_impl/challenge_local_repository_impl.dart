// lib/feature/challenge/data/repo/challenge_local_repository_impl.dart

import 'package:routiner/feature/challenge/data/data_source/local/challenge_local_data_source.dart';
import 'package:routiner/feature/challenge/data/model/challenge_hive_model.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/domain/repo/challenge_local_repository.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_hive_model.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/data/model/habit_log_hive_model.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

class ChallengeLocalRepositoryImpl implements ChallengeLocalRepository {
  ChallengeLocalRepositoryImpl(this._localDataSource);

  final ChallengeLocalDataSource _localDataSource;

  @override
  Future<void> saveChallenge(final ChallengeEntity challenge) {
    final ChallengeHiveModel model = ChallengeHiveModel.fromEntity(challenge);
    return _localDataSource.saveChallenge(model);
  }

  @override
  Future<ChallengeEntity?> getChallengeById(final String challengeId) async {
    final ChallengeHiveModel? model = await _localDataSource.getChallengeById(
      challengeId,
    );
    return model?.toEntity();
  }

  @override
  Future<List<ChallengeEntity>> getAllChallenges() async {
    final List<ChallengeHiveModel> models = await _localDataSource
        .getAllChallenges();
    return models.map((final m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateChallengesList(
      final List<ChallengeEntity> challenges,
      ) {
    final List<ChallengeHiveModel> models = challenges
        .map(ChallengeHiveModel.fromEntity)
        .toList();
    return _localDataSource.updateChallengesList(models);
  }

  @override
  Future<void> deleteChallenge(final String challengeId) {
    return _localDataSource.deleteChallenge(challengeId);
  }

  @override
  Future<void> saveChallengeProgress({
    required final String challengeId,
    required final int totalGoalValue,
    required final int completedValue,
  }) {
    return _localDataSource.saveChallengeProgress(
      challengeId: challengeId,
      totalGoalValue: totalGoalValue,
      completedValue: completedValue,
    );
  }

  @override
  Future<Map<String, dynamic>?> getChallengeProgress(
      final String challengeId,
      ) {
    return _localDataSource.getChallengeProgress(challengeId);
  }

  @override
  Future<void> clearChallengeProgress(final String challengeId) {
    return _localDataSource.clearChallengeProgress(challengeId);
  }

  @override
  Future<void> saveParticipantIds({
    required final String challengeId,
    required final List<String> participantIds,
  }) {
    return _localDataSource.saveParticipantIds(
      challengeId: challengeId,
      participantIds: participantIds,
    );
  }

  @override
  Future<List<String>?> getParticipantIds(final String challengeId) {
    return _localDataSource.getParticipantIds(challengeId);
  }

  @override
  Future<void> saveLastSyncTime(final DateTime syncTime) {
    return _localDataSource.saveLastSyncTime(syncTime);
  }

  @override
  Future<DateTime?> getLastSyncTime() {
    return _localDataSource.getLastSyncTime();
  }

  // ============================================
  // Habit Methods
  // ============================================

  @override
  Future<void> saveHabit(final CustomHabitEntity habit) {
    final CustomHabitHiveModel model = CustomHabitHiveModel.fromEntity(habit);
    return _localDataSource.saveHabit(model);
  }

  @override
  Future<CustomHabitEntity?> getHabitById(final String habitId) async {
    final CustomHabitHiveModel? model = await _localDataSource.getHabitById(
      habitId,
    );
    return model?.toEntity();
  }

  @override
  Future<List<CustomHabitEntity>> getAllHabits() async {
    final List<CustomHabitHiveModel> models = await _localDataSource
        .getAllHabits();
    return models.map((final m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateHabitsList(final List<CustomHabitEntity> habits) {
    final List<CustomHabitHiveModel> models = habits
        .map(CustomHabitHiveModel.fromEntity)
        .toList();
    return _localDataSource.updateHabitsList(models);
  }

  // ============================================
  // Habit Log Methods
  // ============================================

  @override
  Future<void> saveHabitLog(final HabitLogEntity log) {
    final HabitLogHiveModel model = HabitLogHiveModel.fromEntity(log);
    return _localDataSource.saveHabitLog(model);
  }

  @override
  Future<HabitLogEntity?> getHabitLogById(final String logId) async {
    final HabitLogHiveModel? model = await _localDataSource.getHabitLogById(
      logId,
    );
    return model?.toEntity();
  }

  @override
  Future<List<HabitLogEntity>> getAllHabitLogs() async {
    final List<HabitLogHiveModel> models = await _localDataSource
        .getAllHabitLogs();
    return models.map((final m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateHabitLogsList(final List<HabitLogEntity> logs) {
    final List<HabitLogHiveModel> models = logs
        .map(HabitLogHiveModel.fromEntity)
        .toList();
    return _localDataSource.updateHabitLogsList(models);
  }

  // ============================================
  // Friends Count Cache
  // ============================================

  @override
  Future<void> saveFriendsCount(final String habitId, final int count) {
    return _localDataSource.saveFriendsCount(habitId, count);
  }

  @override
  Future<int?> getFriendsCount(final String habitId) {
    return _localDataSource.getFriendsCount(habitId);
  }

  @override
  Future<Map<String, int>> getAllFriendsCounts() {
    return _localDataSource.getAllFriendsCounts();
  }

  @override
  Future<void> clearFriendsCount(final String habitId) {
    return _localDataSource.clearFriendsCount(habitId);
  }
}