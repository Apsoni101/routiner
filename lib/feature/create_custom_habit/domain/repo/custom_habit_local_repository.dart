// lib/feature/create_custom_habit/domain/repository/custom_habit_local_repository.dart

import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';

abstract class CustomHabitLocalRepository {
  Future<void> saveCustomHabit(final CustomHabitEntity habit);

  Future<List<CustomHabitEntity>> getCustomHabits();

  Future<void> deleteCustomHabit(final String id);

  Future<void> updateCustomHabit(final CustomHabitEntity habit);
  Future<void> saveActivity(final ActivityEntity activity);
  Future<List<ActivityEntity>> getActivities({int? limit});
  Future<int> getTotalPoints();
}
