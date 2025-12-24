// lib/feature/challenge/domain/repo/challenge_local_repository.dart

import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

abstract class ChallengeLocalRepository {
  // Challenge CRUD
  Future<void> saveChallenge(final ChallengeEntity challenge);

  Future<ChallengeEntity?> getChallengeById(final String challengeId);

  Future<List<ChallengeEntity>> getAllChallenges();

  Future<void> updateChallengesList(final List<ChallengeEntity> challenges);

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
  Future<void> saveHabit(final CustomHabitEntity habit);

  Future<CustomHabitEntity?> getHabitById(final String habitId);

  Future<List<CustomHabitEntity>> getAllHabits();

  Future<void> updateHabitsList(final List<CustomHabitEntity> habits);

  // Habit Log Methods (for challenge habit logs)
  Future<void> saveHabitLog(final HabitLogEntity log);

  Future<HabitLogEntity?> getHabitLogById(final String logId);

  Future<List<HabitLogEntity>> getAllHabitLogs();

  Future<void> updateHabitLogsList(final List<HabitLogEntity> logs);

  // Friends Count Cache (for challenge habits)
  Future<void> saveFriendsCount(final String habitId, final int count);

  Future<int?> getFriendsCount(final String habitId);

  Future<Map<String, int>> getAllFriendsCounts();

  Future<void> clearFriendsCount(final String habitId);
}