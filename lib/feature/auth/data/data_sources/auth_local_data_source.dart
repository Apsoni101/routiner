import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<Unit> saveUserCredentials(final UserModel user);

  UserModel? getSavedUserCredentials();

  Future<Unit> removeSavedUserCredentials();

  Future<Unit> clearUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  @override
  Future<Unit> saveUserCredentials(final UserModel user) async {
    await _hiveService.setObject<UserModel>(HiveKeyConstants.userKey, user);
    return unit;
  }

  @override
  UserModel? getSavedUserCredentials() {
    return _hiveService.getObject<UserModel>(HiveKeyConstants.userKey);
  }

  @override
  Future<Unit> removeSavedUserCredentials() async {
    await _hiveService.remove(HiveKeyConstants.userKey);
    return unit;
  }

  @override
  Future<Unit> clearUserData() async {
    await _hiveService.clear();
    return unit;
  }
}
