// lib/feature/challenge/domain/usecase/challenge_local_usecase.dart

import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/domain/repo/challenge_local_repository.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

class ChallengeLocalUsecase {
  ChallengeLocalUsecase(this._repository);

  final ChallengeLocalRepository _repository;

  // Challenge CRUD
  Future<void> saveChallenge(final ChallengeEntity challenge) {
    return _repository.saveChallenge(challenge);
  }

  Future<ChallengeEntity?> getChallengeById(final String challengeId) {
    return _repository.getChallengeById(challengeId);
  }

  Future<List<ChallengeEntity>> getAllChallenges() {
    return _repository.getAllChallenges();
  }

  Future<void> updateChallengesList(final List<ChallengeEntity> challenges) {
    return _repository.updateChallengesList(challenges);
  }

  Future<void> deleteChallenge(final String challengeId) {
    return _repository.deleteChallenge(challengeId);
  }

  // Challenge Progress Cache
  Future<void> saveChallengeProgress({
    required final String challengeId,
    required final int totalGoalValue,
    required final int completedValue,
  }) {
    return _repository.saveChallengeProgress(
      challengeId: challengeId,
      totalGoalValue: totalGoalValue,
      completedValue: completedValue,
    );
  }

  Future<Map<String, dynamic>?> getChallengeProgress(
      final String challengeId,
      ) {
    return _repository.getChallengeProgress(challengeId);
  }

  Future<void> clearChallengeProgress(final String challengeId) {
    return _repository.clearChallengeProgress(challengeId);
  }

  // Participant IDs Cache
  Future<void> saveParticipantIds({
    required final String challengeId,
    required final List<String> participantIds,
  }) {
    return _repository.saveParticipantIds(
      challengeId: challengeId,
      participantIds: participantIds,
    );
  }

  Future<List<String>?> getParticipantIds(final String challengeId) {
    return _repository.getParticipantIds(challengeId);
  }

  // Last Sync Timestamp
  Future<void> saveLastSyncTime(final DateTime syncTime) {
    return _repository.saveLastSyncTime(syncTime);
  }

  Future<DateTime?> getLastSyncTime() {
    return _repository.getLastSyncTime();
  }

  // ============================================
  // Habit Methods (for challenge-related operations)
  // ============================================

  Future<void> saveHabit(final CustomHabitEntity habit) {
    return _repository.saveHabit(habit);
  }

  Future<CustomHabitEntity?> getHabitById(final String habitId) {
    return _repository.getHabitById(habitId);
  }

  Future<List<CustomHabitEntity>> getAllHabits() {
    return _repository.getAllHabits();
  }

  Future<void> updateHabitsList(final List<CustomHabitEntity> habits) {
    return _repository.updateHabitsList(habits);
  }

  // ============================================
  // Habit Log Methods (for challenge habit logs)
  // ============================================

  Future<void> saveHabitLog(final HabitLogEntity log) {
    return _repository.saveHabitLog(log);
  }

  Future<HabitLogEntity?> getHabitLogById(final String logId) {
    return _repository.getHabitLogById(logId);
  }

  Future<List<HabitLogEntity>> getAllHabitLogs() {
    return _repository.getAllHabitLogs();
  }

  Future<void> updateHabitLogsList(final List<HabitLogEntity> logs) {
    return _repository.updateHabitLogsList(logs);
  }

  // ============================================
  // Friends Count Cache (for challenge habits)
  // ============================================

  Future<void> saveFriendsCount(final String habitId, final int count) {
    return _repository.saveFriendsCount(habitId, count);
  }

  Future<int?> getFriendsCount(final String habitId) {
    return _repository.getFriendsCount(habitId);
  }

  Future<Map<String, int>> getAllFriendsCounts() {
    return _repository.getAllFriendsCounts();
  }

  Future<void> clearFriendsCount(final String habitId) {
    return _repository.clearFriendsCount(habitId);
  }
}