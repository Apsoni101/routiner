import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/feature/profile/data/local_data_source/create_account_local_data_source.dart';
import 'package:routiner/feature/profile/domain/repo/create_account_repository.dart';


class CreateAccountRepositoryImpl implements CreateAccountRepository {
  CreateAccountRepositoryImpl(this._localDataSource);

  final CreateAccountLocalDataSource _localDataSource;

  @override
  Future<void> saveAccountData({
    required final Gender gender,
    required final Set<Habit> habits,
  }) async {
    await _localDataSource.saveGender(gender);
    await _localDataSource.saveHabits(habits);
  }
}