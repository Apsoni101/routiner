
// lib/feature/add_habit/data/repository/mood_remote_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/add_habit/data/data_source/mood_remote_data_source.dart';
import 'package:routiner/feature/add_habit/data/model/mood_log_model.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';
import 'package:routiner/feature/add_habit/domain/repo/mood_remote_repository.dart';

class MoodRemoteRepositoryImpl implements MoodRemoteRepository {
  MoodRemoteRepositoryImpl(this._remoteDataSource);

  final MoodRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, String>> saveMoodLog(
      final MoodLogEntity moodLog,
      ) async {
    return _remoteDataSource.saveMoodLog(
      moodLog: moodLog.toModel(),
    );
  }

  @override
  Future<Either<Failure, List<MoodLogEntity>>> getMoodLogs() async {
    final Either<Failure, List<MoodLogModel>> result =
    await _remoteDataSource.getMoodLogs();

    return result.fold(
      Left<Failure, List<MoodLogEntity>>.new,
          (final List<MoodLogModel> models) {
        final List<MoodLogEntity> entities = models
            .map((final MoodLogModel model) => model.toEntity())
            .toList();
        return Right<Failure, List<MoodLogEntity>>(entities);
      },
    );
  }

  @override
  Future<Either<Failure, List<MoodLogEntity>>> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    final Either<Failure, List<MoodLogModel>> result =
    await _remoteDataSource.getMoodLogsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );

    return result.fold(
      Left<Failure, List<MoodLogEntity>>.new,
          (final List<MoodLogModel> models) {
        final List<MoodLogEntity> entities = models
            .map((final MoodLogModel model) => model.toEntity())
            .toList();
        return Right<Failure, List<MoodLogEntity>>(entities);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteMoodLog(final String logId) async {
    return _remoteDataSource.deleteMoodLog(logId: logId);
  }

  @override
  Future<Either<Failure, MoodLogEntity?>> getLatestMood() async {
    final Either<Failure, MoodLogModel?> result =
    await _remoteDataSource.getLatestMood();

    return result.fold(
      Left<Failure, MoodLogEntity?>.new,
          (final MoodLogModel? model) {
        if (model == null) {
          return const Right<Failure, MoodLogEntity?>(null);
        }
        return Right<Failure, MoodLogEntity?>(model.toEntity());
      },
    );
  }
}