import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/domain/repositories/auth_remote_repo.dart';

/// Remote repository implementation for authentication operations
class AuthRemoteRepoImpl implements AuthRemoteRepo {
  /// Creates an instance of AuthRemoteRepoImpl
  AuthRemoteRepoImpl({
    required this.authRemoteDataSource,
  });

  /// Remote data source for performing authentication operations
  final AuthRemoteDataSource authRemoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndData(
      final String email,
      final String password,
      final String name,
      final String surname,
      final String birthdate,
      ) async {
    final Either<Failure, UserModel> result = await authRemoteDataSource
        .signUpWithEmailAndData(email, password, name, surname, birthdate);

    return result.fold(
      Left.new,
          Right<Failure, UserEntity>.new,
    );
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail(
      final String email,
      final String password,
      ) async {
    final Either<Failure, UserModel> result =
    await authRemoteDataSource.signInWithEmail(email, password);

    return result.fold(
      Left.new,
          (final UserModel userModel) => Right<Failure, UserEntity>(userModel),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    final Either<Failure, UserModel> result =
    await authRemoteDataSource.signInWithGoogle();

    return result.fold(
      Left.new,
          (final UserModel userModel) => Right<Failure, UserEntity>(userModel),
    );
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    return await authRemoteDataSource.signOut();
  }

  @override
  bool isSignedIn() => authRemoteDataSource.isSignedIn();
}