import 'package:dartz/dartz.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';

abstract class AuthLocalRepo {
  Future<Unit> saveUserCredentials(UserEntity user);

  UserEntity? getSavedUserCredentials();

  Future<Unit> removeSavedUserCredentials();

  Future<Unit> clearUserData();

  UserEntity? getCurrentUser();
}
