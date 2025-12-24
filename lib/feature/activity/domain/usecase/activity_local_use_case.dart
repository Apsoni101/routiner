import 'package:routiner/feature/activity/domain/repo/activity_local_repo.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';

/// Use case for activity local operations
class ActivityLocalUseCase {
  ActivityLocalUseCase(this._repository);

  final ActivityLocalRepository _repository;

  /// Get mood logs for date range
  List<MoodLogEntity> getMoodLogs({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _repository.getMoodLogs(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Get the latest mood log
  MoodLogEntity? getLatestMoodLog() {
    return _repository.getLatestMoodLog();
  }
}