import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';
import 'package:routiner/feature/home/domain/repo/habits_display_remote_repository.dart';

class HabitsDisplayRemoteUsecase {
  HabitsDisplayRemoteUsecase(this._repository);

  final HabitsDisplayRemoteRepository _repository;

  /// Save or update a log for a habit on a specific date
  Future<Either<Failure, Unit>> saveLog({
    required final String habitId,
    required final HabitLogEntity log,
  }) {
    return _repository.saveLog(
      habitId: habitId,
      log: log,
    );
  }

  /// Get a log for a habit on a specific date
  Future<Either<Failure, HabitLogEntity?>> getLogForDate({
    required final String habitId,
    required final String date,
  }) {
    return _repository.getLogForDate(
      habitId: habitId,
      date: date,
    );
  }

  /// Get all logs for a specific habit
  Future<Either<Failure, List<HabitLogEntity>>> getLogsForHabit({
    required final String habitId,
  }) {
    return _repository.getLogsForHabit(
      habitId: habitId,
    );
  }

  /// Delete a log for a habit on a specific date
  Future<Either<Failure, Unit>> deleteLog({
    required final String habitId,
    required final String date,
  }) {
    return _repository.deleteLog(
      habitId: habitId,
      date: date,
    );
  }

  /// Get the number of friends who have the same goal/habit
  Future<Either<Failure, int>> getFriendsWithSameGoalCount({
    required final String habitName,
  }) {
    return _repository.getFriendsWithSameGoalCount(
      habitName: habitName,
    );
  }
}
