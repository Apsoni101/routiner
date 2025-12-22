import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/habits_list/domain/repo/habits_list_remote_repository.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

class HabitsListRemoteUsecase {
  HabitsListRemoteUsecase(this._repository);

  final HabitsListRemoteRepository _repository;

  /// Save or update a log for a habit on a specific date
  Future<Either<Failure, Unit>> saveLog({
    required String habitId,
    required HabitLogEntity log,
  }) {
    return _repository.saveLog(
      habitId: habitId,
      log: log,
    );
  }

  /// Get a log for a habit on a specific date
  Future<Either<Failure, HabitLogEntity?>> getLogForDate({
    required String habitId,
    required String date, // YYYY-MM-DD
  }) {
    return _repository.getLogForDate(
      habitId: habitId,
      date: date,
    );
  }

  /// Get all logs for a specific habit
  Future<Either<Failure, List<HabitLogEntity>>> getLogsForHabit({
    required String habitId,
  }) {
    return _repository.getLogsForHabit(
      habitId: habitId,
    );
  }

  /// Delete a log for a habit on a specific date
  Future<Either<Failure, Unit>> deleteLog({
    required String habitId,
    required String date,
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
