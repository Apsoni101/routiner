// lib/feature/profile/domain/repo/create_account_remote_repository.dart

import 'package:dartz/dartz.dart';
import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';

abstract class CreateAccountRemoteRepository {
  /// Save account data (gender and habits) to remote
  Future<Either<Failure, Unit>> saveAccountData({
    required Gender gender,
    required List<CustomHabitEntity> habits,
  });

  /// Get account data from remote
  Future<Either<Failure, Map<String, dynamic>>> getAccountData();

  /// Update gender on remote
  Future<Either<Failure, Unit>> updateGender({required Gender gender});
}