import 'package:dartz/dartz.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/domain/repositories/auth_local_repo.dart';

class AuthLocalUseCase {
  AuthLocalUseCase({required this.authLocalRepo});

  final AuthLocalRepo authLocalRepo;

  Future<Unit> saveUserCredentials(UserEntity user) =>
      authLocalRepo.saveUserCredentials(user);

  UserEntity? getSavedUserCredentials() =>
      authLocalRepo.getSavedUserCredentials();

  Future<Unit> removeSavedUserCredentials() =>
      authLocalRepo.removeSavedUserCredentials();

  Future<Unit> clearUserData() =>
      authLocalRepo.clearUserData();

  UserEntity? getCurrentUser() =>
      authLocalRepo.getCurrentUser();
}
