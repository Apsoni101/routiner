// lib/feature/add_habit/domain/repo/mood_local_repository.dart

import 'package:routiner/feature/add_habit/data/model/mood_log_hive_model.dart';

abstract class MoodLocalRepository {
  // Current mood state operations
  Future<void> saveMood(final String mood, final DateTime timestamp);
  Map<String, dynamic>? getMood();
  Future<void> clearMood();

  // Mood logs (history) operations
  Future<void> saveMoodLog(final MoodLogHiveModel moodLog);
  List<MoodLogHiveModel> getAllMoodLogs();
  List<MoodLogHiveModel> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  });
  Future<void> deleteMoodLog(final String logId);
  Future<void> clearAllMoodLogs();
}
