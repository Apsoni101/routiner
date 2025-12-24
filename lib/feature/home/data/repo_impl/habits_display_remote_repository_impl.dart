import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/data/model/challenge_model.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_model.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/home/data/data_source/remote_data_source/habits_display_remote_data_source.dart';
import 'package:routiner/feature/home/data/model/habit_log_hive_model.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';
import 'package:routiner/feature/home/domain/repo/habits_display_remote_repository.dart';

class HabitsDisplayRemoteRepositoryImpl
    implements HabitsDisplayRemoteRepository {
  HabitsDisplayRemoteRepositoryImpl(this._remoteDataSource);

  final HabitsDisplayRemoteDataSource _remoteDataSource;

  /// Save / update a log for a habit on a specific date
  /// Entity ➜ HiveModel
  @override
  Future<Either<Failure, Unit>> saveLog({
    required final String habitId,
    required final HabitLogEntity log,
  }) {
    return _remoteDataSource.saveLog(
      habitId: habitId,
      log: HabitLogHiveModel.fromEntity(log),
    );
  }

  /// Get log for a habit on a specific date
  /// HiveModel ➜ Entity
  @override
  Future<Either<Failure, HabitLogEntity?>> getLogForDate({
    required final String habitId,
    required final String date,
  }) async {
    final Either<Failure, HabitLogHiveModel?> result = await _remoteDataSource
        .getLogForDate(habitId: habitId, date: date);

    return result.fold(
      Left.new,
      (final HabitLogHiveModel? model) =>
          model == null ? const Right(null) : Right(model.toEntity()),
    );
  }

  /// Get all logs for a specific habit
  /// HiveModel ➜ Entity list
  @override
  Future<Either<Failure, List<HabitLogEntity>>> getLogsForHabit({
    required final String habitId,
  }) async {
    final Either<Failure, List<HabitLogHiveModel>> result =
        await _remoteDataSource.getLogsForHabit(habitId: habitId);

    return result.fold(
      Left.new,
      (final List<HabitLogHiveModel> models) => Right(
        models.map((final HabitLogHiveModel m) => m.toEntity()).toList(),
      ),
    );
  }

  /// Delete a log for a habit on a specific date
  @override
  Future<Either<Failure, Unit>> deleteLog({
    required final String habitId,
    required final String date,
  }) {
    return _remoteDataSource.deleteLog(habitId: habitId, date: date);
  }

  @override
  Future<Either<Failure, int>> getFriendsWithSameGoalCount({
    required final String habitName,
  }) {
    return _remoteDataSource.getFriendsWithSameGoalCount(habitName: habitName);
  }
  @override
  Future<Either<Failure, List<ChallengeEntity>>> getAllChallenges() async {
    final Either<Failure, List<ChallengeModel>> result =
    await _remoteDataSource.getAllChallenges();

    return result.fold(
      Left.new,
          (final List<ChallengeModel> models) =>
          Right(models.map((final ChallengeModel m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, Unit>> saveActivity(final ActivityEntity activity) {
    final ActivityModel model = ActivityModel.fromEntity(activity);
    return _remoteDataSource.saveActivity(activity: model);
  }

  @override
  Future<Either<Failure, int>> getTotalPoints() {
    return _remoteDataSource.getTotalPoints();
  }

  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivities({int? limit}) async {
    final Either<Failure, List<ActivityModel>> result =
    await _remoteDataSource.getActivities(limit: limit);
    return result.fold(
      Left.new,
          (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }
}
