import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/enums/habits.dart';

abstract class CreateAccountRepository {
  Future<void> saveAccountData({
    required final Gender gender,
    required final Set<Habit> habits,
  });
}
