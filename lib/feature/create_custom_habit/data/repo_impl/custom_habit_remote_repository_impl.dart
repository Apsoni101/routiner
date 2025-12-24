// lib/feature/create_custom_habit/data/repository/custom_habit_local_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/data/data_source/custom_habit_remote_data_source.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_model.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/repo/custom_habit_remote_repository.dart';

class CustomHabitRemoteRepositoryImpl implements CustomHabitRemoteRepository {
  CustomHabitRemoteRepositoryImpl(this._remoteDataSource);

  final CustomHabitRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, String>> saveCustomHabit(
    final CustomHabitEntity habit,
  ) => _remoteDataSource.saveCustomHabit(habit: habit.toModel());

  @override
  Future<Either<Failure, List<CustomHabitEntity>>> getCustomHabits() =>
      _remoteDataSource.getCustomHabits();

  @override
  Future<Either<Failure, CustomHabitEntity>> getCustomHabit(
    final String habitId,
  ) => _remoteDataSource.getCustomHabit(habitId: habitId);

  @override
  Future<Either<Failure, Unit>> updateCustomHabit(
    final CustomHabitEntity habit,
  ) => _remoteDataSource.updateCustomHabit(habit: habit.toModel());

  @override
  Future<Either<Failure, Unit>> deleteCustomHabit(final String habitId) =>
      _remoteDataSource.deleteCustomHabit(habitId: habitId);

  @override
  Future<Either<Failure, bool>> habitExists(final String habitId) =>
      _remoteDataSource.habitExists(habitId: habitId);

  @override
  Future<Either<Failure, Unit>> saveActivity(final ActivityEntity activity) {
    final ActivityModel model = ActivityModel.fromEntity(activity);
    return _remoteDataSource.saveActivity(activity: model);
  }

  @override
  Future<Either<Failure, int>> getTotalPoints() =>
      _remoteDataSource.getTotalPoints();

  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivities({
    int? limit,
  }) async {
    final Either<Failure, List<ActivityModel>> result = await _remoteDataSource
        .getActivities(limit: limit);

    return result.fold(
      Left.new,
      (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }
}
