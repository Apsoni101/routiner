// lib/feature/create_custom_habit/domain/usecases/create_custom_habit_remote_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/repo/custom_habit_remote_repository.dart';

class CreateCustomHabitRemoteUsecase {
  CreateCustomHabitRemoteUsecase(this._repository);

  final CustomHabitRemoteRepository _repository;

  /// Save or create a custom habit
  Future<Either<Failure, String>> call(final CustomHabitEntity habit) {
    return _repository.saveCustomHabit(habit);
  }

  /// Get all custom habits
  Future<Either<Failure, List<CustomHabitEntity>>> getCustomHabits() {
    return _repository.getCustomHabits();
  }

  /// Get a single custom habit by ID
  Future<Either<Failure, CustomHabitEntity>> getCustomHabit(
    final String habitId,
  ) {
    return _repository.getCustomHabit(habitId);
  }

  /// Update an existing custom habit
  Future<Either<Failure, Unit>> updateCustomHabit(
    final CustomHabitEntity habit,
  ) {
    return _repository.updateCustomHabit(habit);
  }

  /// Delete a custom habit
  Future<Either<Failure, Unit>> deleteCustomHabit(final String habitId) {
    return _repository.deleteCustomHabit(habitId);
  }

  /// Check if a habit exists
  Future<Either<Failure, bool>> habitExists(final String habitId) {
    return _repository.habitExists(habitId);
  }
}
