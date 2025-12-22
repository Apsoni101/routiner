// lib/feature/profile/data/repository/create_account_remote_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/profile/data/data_source/remote_data_sources/create_account_remote_data_source.dart';
import 'package:routiner/feature/profile/domain/repo/create_account_remote_repository.dart';

class CreateAccountRemoteRepositoryImpl
    implements CreateAccountRemoteRepository {
  CreateAccountRemoteRepositoryImpl(this._remoteDataSource);

  final CreateAccountRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Unit>> saveAccountData({
    required Gender gender,
    required List<CustomHabitEntity> habits,
  }) async {
    return _remoteDataSource.saveAccountData(
      gender: gender,
      habits: habits
          .map((final CustomHabitEntity habit) => habit.toModel())
          .toList(),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAccountData() async {
    return _remoteDataSource.getAccountData();
  }

  @override
  Future<Either<Failure, Unit>> updateGender({
    required Gender gender,
  }) async {
    return _remoteDataSource.updateGender(gender: gender);
  }
}