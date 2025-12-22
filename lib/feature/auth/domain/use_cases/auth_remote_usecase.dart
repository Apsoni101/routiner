import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/domain/repositories/auth_remote_repo.dart';

/// Use case for remote authentication operations
class AuthRemoteUseCase {
  /// Creates an instance of AuthRemoteUseCase
  AuthRemoteUseCase({required this.authRemoteRepo});

  /// Remote authentication repository
  final AuthRemoteRepo authRemoteRepo;

  /// Signs up a new user with email, password, and additional data
  Future<Either<Failure, UserEntity>> signUpWithEmailAndData(
      final String email,
      final String password,
      final String name,
      final String surname,
      final String birthdate,
      ) => authRemoteRepo.signUpWithEmailAndData(email, password, name, surname, birthdate);

  /// Signs in the user using Google authentication
  Future<Either<Failure, UserEntity>> signInWithGoogle() =>
      authRemoteRepo.signInWithGoogle();

  /// Signs out the currently authenticated user
  Future<Either<Failure, Unit>> signOut() => authRemoteRepo.signOut();

  /// Signs in an existing user using email and password
  Future<Either<Failure, UserEntity>> signInWithEmail(
      final String email,
      final String password,
      ) => authRemoteRepo.signInWithEmail(email, password);

  /// Checks if user is signed in with remote service
  bool isSignedIn() => authRemoteRepo.isSignedIn();
}