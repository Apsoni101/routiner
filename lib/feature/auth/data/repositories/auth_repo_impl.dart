import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/data_sources/auth_local_data_source.dart';
import 'package:routiner/feature/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/domain/repositories/auth_repo.dart';


///  Repository impl that defines authentication-related operations.
class AuthRepoImpl implements AuthRepo {
  /// Creates an instance of authRepoImpl.
  AuthRepoImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  /// Remote data source for performing authentication operations.
  final AuthRemoteDataSource authRemoteDataSource;

  /// Local data source for saving user credentials locally.
  final AuthLocalDataSource authLocalDataSource;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail(
    final String email,
    final String password,
  ) async {
    final Either<Failure, UserModel> result = await authRemoteDataSource
        .signInWithEmail(email, password);

    return result.fold(Left.new, (final UserModel userModel) async {
      await authLocalDataSource.saveUserCredentials(userModel);
      return Right<Failure, UserEntity>(userModel);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    final Either<Failure, UserModel> result =
        await authRemoteDataSource.signInWithGoogle();

    return result.fold(Left.new, (final UserModel userModel) async {
      await authLocalDataSource.saveUserCredentials(userModel);
      return Right<Failure, UserEntity>(userModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    final Either<Failure, Unit> remoteResult =
        await authRemoteDataSource.signOut();

    return remoteResult.fold(Left.new, (_) async {
      final Either<Failure, Unit> localResult =
          await authLocalDataSource.removeSavedUserCredentials();
      return localResult.fold(
        Left.new,
        (_) => const Right<Failure, Unit>(unit),
      );
    });
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail(
      final String email,
    final String password,
  ) async {
    final Either<Failure, UserModel> result = await authRemoteDataSource
        .signUpWithEmail(email, password);

    return result.fold(Left.new, (final UserModel userModel) async {
      await authLocalDataSource.saveUserCredentials(userModel);
      return Right<Failure, UserEntity>(userModel);
    });
  }

  @override
  bool isSignedIn() => authRemoteDataSource.isSignedIn();

}
