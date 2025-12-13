import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/services/storage/hive_service.dart';

abstract class CreateAccountLocalDataSource {
  Future<void> saveGender(final Gender gender);

  Future<void> saveHabits(final Set<Habit> habits);
}

class CreateAccountLocalDataSourceImpl implements CreateAccountLocalDataSource {
  CreateAccountLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  static const String _genderKey = 'user_gender';
  static const String _habitsKey = 'user_habits';
  static const String _accountSetupKey = 'account_setup_complete';

  @override
  Future<void> saveGender(final Gender gender) async {
    await _hiveService.setString(_genderKey, gender.name);
  }

  @override
  Future<void> saveHabits(final Set<Habit> habits) async {
    final List<String> habitNames = habits
        .map((final Habit h) => h.name)
        .toList();
    await _hiveService.setStringList(_habitsKey, habitNames);
    await _hiveService.setBool(key: _accountSetupKey, value: true);
  }
}
