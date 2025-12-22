import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/profile/data/data_source/local_data_sources/create_account_local_data_source.dart';
import 'package:routiner/feature/profile/domain/repo/create_account_local_repository.dart';

class CreateAccountLocalRepositoryImpl implements CreateAccountLocalRepository {
  CreateAccountLocalRepositoryImpl(this._localDataSource);

  final CreateAccountLocalDataSource _localDataSource;

  @override
  Future<void> saveAccountData({
    required final Gender gender,
    required final List<CustomHabitEntity> habits,
  }) async {
    await _localDataSource.saveGender(gender);

    await _localDataSource.saveCustomHabits(
      habits.map((final CustomHabitEntity habit) {
        return habit.toModel();
      }).toList(),
    );
  }
}
