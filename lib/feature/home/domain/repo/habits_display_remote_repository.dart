import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

abstract class HabitsDisplayRemoteRepository {
  /// Save or update a log for a habit on a specific date
  Future<Either<Failure, Unit>> saveLog({
    required final String habitId,
    required final HabitLogEntity log,
  });

  /// Get log for a habit on a specific date
  /// Returns null if no log exists for that day
  Future<Either<Failure, HabitLogEntity?>> getLogForDate({
    required final String habitId,
    required final String date, // YYYY-MM-DD
  });

  /// Get all logs for a specific habit
  Future<Either<Failure, List<HabitLogEntity>>> getLogsForHabit({
    required final String habitId,
  });

  /// Delete log for a habit on a specific date
  Future<Either<Failure, Unit>> deleteLog({
    required final String habitId,
    required final String date,
  });

  Future<Either<Failure, int>> getFriendsWithSameGoalCount({
    required final String habitName,
  });
  Future<Either<Failure, List<ChallengeEntity>>> getAllChallenges();
  Future<Either<Failure, Unit>> saveActivity(final ActivityEntity activity);
  Future<Either<Failure, int>> getTotalPoints();
  Future<Either<Failure, List<ActivityEntity>>> getActivities({int? limit});
}
