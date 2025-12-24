// lib/feature/add_habit/domain/usecase/mood_remote_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';
import 'package:routiner/feature/add_habit/domain/repo/mood_remote_repository.dart';

class MoodRemoteUsecase {
  MoodRemoteUsecase(this._repository);

  final MoodRemoteRepository _repository;

  Future<Either<Failure, String>> saveMoodLog(
      final MoodLogEntity moodLog,
      ) {
    return _repository.saveMoodLog(moodLog);
  }

  Future<Either<Failure, List<MoodLogEntity>>> getMoodLogs() {
    return _repository.getMoodLogs();
  }

  Future<Either<Failure, List<MoodLogEntity>>> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  }) {
    return _repository.getMoodLogsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<Either<Failure, Unit>> deleteMoodLog(final String logId) {
    return _repository.deleteMoodLog(logId);
  }

  Future<Either<Failure, MoodLogEntity?>> getLatestMood() {
    return _repository.getLatestMood();
  }
}