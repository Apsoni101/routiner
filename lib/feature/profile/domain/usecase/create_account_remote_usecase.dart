// lib/feature/profile/domain/usecase/create_account_remote_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/profile/domain/repo/create_account_remote_repository.dart';

class CreateAccountRemoteUsecase {
  CreateAccountRemoteUsecase(this._repository);

  final CreateAccountRemoteRepository _repository;

  /// Save account data (gender and habits) to remote
  Future<Either<Failure, Unit>> saveAccountData({
    required Gender gender,
    required List<CustomHabitEntity> habits,
  }) {
    return _repository.saveAccountData(gender: gender, habits: habits);
  }

  /// Get account data from remote
  Future<Either<Failure, Map<String, dynamic>>> getAccountData() {
    return _repository.getAccountData();
  }

  /// Update gender on remote
  Future<Either<Failure, Unit>> updateGender({required Gender gender}) {
    return _repository.updateGender(gender: gender);
  }
}