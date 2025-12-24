import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/activity/data/data_source/remote/activity_remote_data_source.dart';
import 'package:routiner/feature/activity/domain/repo/activity_remote_repository.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';

class ActivityRemoteRepositoryImpl implements ActivityRemoteRepository {
  ActivityRemoteRepositoryImpl({required this.remoteDataSource});

  final ActivityRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getLogsForDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    return remoteDataSource.getLogsForDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<Either<Failure, List<MoodLogEntity>>> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    final result = await remoteDataSource.getMoodLogsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );

    return result.fold(
      Left.new,
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }
}
