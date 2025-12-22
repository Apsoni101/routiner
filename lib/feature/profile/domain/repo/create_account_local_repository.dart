import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';

abstract class CreateAccountLocalRepository {
  Future<void> saveAccountData({
    required final Gender gender,
    required final List<CustomHabitEntity> habits,
  });
}
