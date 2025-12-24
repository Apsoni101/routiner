// lib/feature/add_habit/domain/usecase/mood_local_usecase.dart

import 'package:routiner/feature/add_habit/data/model/mood_log_hive_model.dart';
import 'package:routiner/feature/add_habit/domain/repo/mood_local_repository.dart';

class MoodLocalUsecase {
  MoodLocalUsecase(this._repository);

  final MoodLocalRepository _repository;

  // ===================================
  // Current Mood State Operations
  // ===================================

  /// Save current mood state (for quick access)
  Future<void> saveMood(final String mood, final DateTime timestamp) {
    return _repository.saveMood(mood, timestamp);
  }

  /// Get current mood state
  Map<String, dynamic>? getMood() {
    return _repository.getMood();
  }

  /// Clear current mood state
  Future<void> clearMood() {
    return _repository.clearMood();
  }

  // ===================================
  // Mood Logs (History) Operations
  // ===================================

  /// Save mood log to local storage (for offline access)
  Future<void> saveMoodLog(final MoodLogHiveModel moodLog) {
    return _repository.saveMoodLog(moodLog);
  }

  /// Get all mood logs from local storage
  List<MoodLogHiveModel> getAllMoodLogs() {
    return _repository.getAllMoodLogs();
  }

  /// Get mood logs by date range from local storage
  List<MoodLogHiveModel> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  }) {
    return _repository.getMoodLogsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Delete a mood log from local storage
  Future<void> deleteMoodLog(final String logId) {
    return _repository.deleteMoodLog(logId);
  }

  /// Clear all mood logs from local storage
  Future<void> clearAllMoodLogs() {
    return _repository.clearAllMoodLogs();
  }

  /// Get the latest mood log from local storage
  MoodLogHiveModel? getLatestMoodLog() {
    final List<MoodLogHiveModel> logs = getAllMoodLogs();
    if (logs.isEmpty) return null;

    // Sort by timestamp descending and return first
    logs.sort((final MoodLogHiveModel a, final MoodLogHiveModel b) =>
        DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));

    return logs.first;
  }
}