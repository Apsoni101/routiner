import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/profile/domain/repo/create_account_local_repository.dart';

class CreateAccountLocalUsecase {
  CreateAccountLocalUsecase(this._repository);

  final CreateAccountLocalRepository _repository;

  Future<void> saveAccountData({
    required final Gender gender,
    required final List<CustomHabitEntity> habits,
  }) {
    return _repository.saveAccountData(gender: gender, habits: habits);
  }
}
