// lib/feature/create_custom_habit/domain/usecases/create_custom_habit_local_use_case.dart

import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/repo/custom_habit_local_repository.dart';

class CreateCustomHabitLocalUsecase {
  CreateCustomHabitLocalUsecase(this._repository);

  final CustomHabitLocalRepository _repository;

  Future<void> createCustomHabit(final CustomHabitEntity habit) {
    return _repository.saveCustomHabit(habit);
  }

  Future<List<CustomHabitEntity>> getCustomHabits() {
    return _repository.getCustomHabits();
  }

  Future<void> deleteCustomHabit(final String id) {
    return _repository.deleteCustomHabit(id);
  }

  Future<void> updateCustomHabit(final CustomHabitEntity habit) {
    return _repository.updateCustomHabit(habit);
  }
  Future<void> saveActivity(final ActivityEntity activity) {
    return _repository.saveActivity(activity);
  }

  Future<List<ActivityEntity>> getActivities({int? limit}) {
    return _repository.getActivities(limit: limit);
  }

  Future<int> getTotalPoints() {
    return _repository.getTotalPoints();
  }
}
