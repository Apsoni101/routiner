import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';

abstract class ActivityRemoteRepository {
  /// Get habit logs for a date range
  Future<Either<Failure, List<Map<String, dynamic>>>> getLogsForDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  });

  /// Get mood logs for a date range
  Future<Either<Failure, List<MoodLogEntity>>> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  });
}