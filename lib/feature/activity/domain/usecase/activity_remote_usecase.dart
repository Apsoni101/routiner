import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/activity/domain/repo/activity_remote_repository.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';

/// Use case for activity remote operations
class ActivityRemoteUseCase {
  ActivityRemoteUseCase({required this.repository});

  final ActivityRemoteRepository repository;

  /// Get habit logs for date range
  Future<Either<Failure, List<Map<String, dynamic>>>> getHabitLogs({
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    return repository.getLogsForDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Get mood logs for date range
  Future<Either<Failure, List<MoodLogEntity>>> getMoodLogs({
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    return repository.getMoodLogsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }
}