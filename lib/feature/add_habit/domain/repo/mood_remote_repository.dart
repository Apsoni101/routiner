// lib/feature/add_habit/domain/repo/mood_remote_repository.dart

import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';

abstract class MoodRemoteRepository {
  Future<Either<Failure, String>> saveMoodLog(final MoodLogEntity moodLog);
  Future<Either<Failure, List<MoodLogEntity>>> getMoodLogs();
  Future<Either<Failure, List<MoodLogEntity>>> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  });
  Future<Either<Failure, Unit>> deleteMoodLog(final String logId);
  Future<Either<Failure, MoodLogEntity?>> getLatestMood();
}
