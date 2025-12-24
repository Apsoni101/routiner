
import 'package:routiner/feature/add_habit/data/data_source/mood_local_data_source.dart';
import 'package:routiner/feature/add_habit/data/model/mood_log_hive_model.dart';
import 'package:routiner/feature/add_habit/domain/repo/mood_local_repository.dart';

class MoodLocalRepositoryImpl implements MoodLocalRepository {
  MoodLocalRepositoryImpl(this._localDataSource);

  final MoodLocalDataSource _localDataSource;

  // Current mood state operations
  @override
  Future<void> saveMood(final String mood, final DateTime timestamp) async {
    await _localDataSource.saveMood(mood, timestamp);
  }

  @override
  Map<String, dynamic>? getMood() {
    return _localDataSource.getMood();
  }

  @override
  Future<void> clearMood() async {
    await _localDataSource.clearMood();
  }

  // Mood logs (history) operations
  @override
  Future<void> saveMoodLog(final MoodLogHiveModel moodLog) async {
    await _localDataSource.saveMoodLog(moodLog);
  }

  @override
  List<MoodLogHiveModel> getAllMoodLogs() {
    return _localDataSource.getAllMoodLogs();
  }

  @override
  List<MoodLogHiveModel> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  }) {
    return _localDataSource.getMoodLogsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<void> deleteMoodLog(final String logId) async {
    await _localDataSource.deleteMoodLog(logId);
  }

  @override
  Future<void> clearAllMoodLogs() async {
    await _localDataSource.clearAllMoodLogs();
  }
}