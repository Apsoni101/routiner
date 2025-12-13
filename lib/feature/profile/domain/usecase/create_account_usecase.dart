import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/feature/profile/domain/repo/create_account_repository.dart';

class CreateAccountUsecase {
  CreateAccountUsecase(this._repository);

  final CreateAccountRepository _repository;

  Future<void> createAccount({
    required final Gender gender,
    required final Set<Habit> habits,
  }) {
    return _repository.saveAccountData(gender: gender, habits: habits);
  }
}
