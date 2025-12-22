import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';

/// Abstract repository for remote authentication operations
abstract class AuthRemoteRepo {
  /// Signs up a new user with email, password, and additional data
  Future<Either<Failure, UserEntity>> signUpWithEmailAndData(
      final String email,
      final String password,
      final String name,
      final String surname,
      final String birthdate,
      );

  /// Signs in the user using Google authentication
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Signs in an existing user using email and password
  Future<Either<Failure, UserEntity>> signInWithEmail(
      final String email,
      final String password,
      );

  /// Signs out the currently authenticated user
  Future<Either<Failure, Unit>> signOut();

  /// Checks if user is signed in with remote service
  bool isSignedIn();
}