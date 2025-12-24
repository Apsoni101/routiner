// lib/feature/create_custom_habit/domain/repo/custom_habit_local_repository.dart

import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';

abstract class CustomHabitRemoteRepository {
  Future<Either<Failure, String>> saveCustomHabit(
    final CustomHabitEntity habit,
  );

  Future<Either<Failure, List<CustomHabitEntity>>> getCustomHabits();

  Future<Either<Failure, CustomHabitEntity>> getCustomHabit(
    final String habitId,
  );

  Future<Either<Failure, Unit>> updateCustomHabit(
    final CustomHabitEntity habit,
  );

  Future<Either<Failure, Unit>> deleteCustomHabit(final String habitId);

  Future<Either<Failure, bool>> habitExists(final String habitId);
  Future<Either<Failure, Unit>> saveActivity(final ActivityEntity activity);
  Future<Either<Failure, int>> getTotalPoints();
  Future<Either<Failure, List<ActivityEntity>>> getActivities({int? limit});
}
