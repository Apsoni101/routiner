import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/domain/repositories/auth_repo.dart';


/// authUsecase repository that defines authentication-related usecase.
class AuthUseCase {
  /// Creates an instance of authUsecase.
  AuthUseCase({required this.authRepo});

  /// Creates an instance of authRepo.
  final AuthRepo authRepo;

  /// Signs in the user using Google authentication.
  Future<Either<Failure, UserEntity>> signInWithGoogle() =>
      authRepo.signInWithGoogle();

  /// Signs out the currently authenticated user.
  Future<Either<Failure, Unit>> signOut() => authRepo.signOut();

  /// Signs up a new user using email and password.
  Future<Either<Failure, UserEntity>> signUpWithEmail(
    final String email,
    final String password,
  ) => authRepo.signUpWithEmail( email, password);

  /// Signs in an existing user using email and password.
  Future<Either<Failure, UserEntity>> signInWithEmail(
    final String email,
    final String password,
  ) => authRepo.signInWithEmail(email, password);

  ///used for checking signIn
  bool isSignedIn() => authRepo.isSignedIn();

}
