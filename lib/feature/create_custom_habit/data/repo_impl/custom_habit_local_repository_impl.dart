// lib/feature/create_custom_habit/data/repository/custom_habit_local_repository_impl.dart

import 'package:routiner/feature/create_custom_habit/data/data_source/custom_habit_local_data_source.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/repo/custom_habit_local_repository.dart';

class CustomHabitLocalRepositoryImpl implements CustomHabitLocalRepository {
  CustomHabitLocalRepositoryImpl(this._localDataSource);

  final CustomHabitLocalDataSource _localDataSource;

  @override
  Future<void> saveCustomHabit(final CustomHabitEntity habit) async {
    await _localDataSource.saveCustomHabit(habit.toModel());
  }

  @override
  Future<List<CustomHabitEntity>> getCustomHabits() async {
    return _localDataSource.getCustomHabits();
  }

  @override
  Future<void> deleteCustomHabit(final String id) async {
    await _localDataSource.deleteCustomHabit(id);
  }

  @override
  Future<void> updateCustomHabit(final CustomHabitEntity habit) async {
    await _localDataSource.updateCustomHabit(habit.toModel());
  }
}
