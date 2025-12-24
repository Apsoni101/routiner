import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';

abstract class ActivityLocalRepository {
  /// Get mood logs for a date range
  List<MoodLogEntity> getMoodLogs({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get the latest mood log
  MoodLogEntity? getLatestMoodLog();
}