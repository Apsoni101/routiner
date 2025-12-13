import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/core/services/storage/shared_prefs_keys.dart';
import 'package:routiner/core/services/storage/shared_prefs_service.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';

/// Abstract auth local data source for local storage operations
abstract class AuthLocalDataSource {
  /// Save user credentials locally
  Future<Either<Failure, Unit>> saveUserCredentials(final UserModel user);

  /// Get saved user credentials
  Either<Failure, UserModel?> getSavedUserCredentials();

  /// Remove saved user credentials
  Future<Either<Failure, Unit>> removeSavedUserCredentials();
}

/// Implementation of auth local data source using SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  /// Creates an instance of AuthLocalDataSourceImpl
  AuthLocalDataSourceImpl({required this.sharedPrefsService});

  /// SharedPreferences service for local storage
  final SharedPrefsService sharedPrefsService;

  @override
  Future<Either<Failure, Unit>> saveUserCredentials(
    final UserModel user,
  ) async {
    try {
      await sharedPrefsService.setString(SharedPrefsKeys.userUid, user.uid);
      await sharedPrefsService.setString(SharedPrefsKeys.userEmail, user.email);
      await sharedPrefsService.setString(SharedPrefsKeys.userName, user.name);
      return const Right<Failure, Unit>(unit);
    } catch (e) {
      return Left<Failure, Unit>(
        Failure(message: 'Failed to save user credentials: $e'),
      );
    }
  }

  @override
  Either<Failure, UserModel?> getSavedUserCredentials() {
    try {
      final String? uid = sharedPrefsService.getString(SharedPrefsKeys.userUid);
      final String? name = sharedPrefsService.getString(
        SharedPrefsKeys.userName,
      );
      final String? email = sharedPrefsService.getString(
        SharedPrefsKeys.userEmail,
      );

      if (uid != null && name != null && email != null) {
        return Right<Failure, UserModel?>(
          UserModel(uid: uid, name: name, email: email),
        );
      }
      return const Right<Failure, UserModel?>(null);
    } catch (e) {
      return Left<Failure, UserModel?>(
        Failure(message: 'Failed to get saved user credentials: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> removeSavedUserCredentials() async {
    try {
      await sharedPrefsService.remove(SharedPrefsKeys.userUid);
      await sharedPrefsService.remove(SharedPrefsKeys.userEmail);
      return const Right<Failure, Unit>(unit);
    } catch (e) {
      return Left<Failure, Unit>(
        Failure(message: 'Failed to remove user credentials: $e'),
      );
    }
  }
}
