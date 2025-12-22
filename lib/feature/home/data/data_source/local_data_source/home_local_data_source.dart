import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/core/services/storage/hive_service.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';

abstract class HomeLocalDataSource {
  String? getMood();

  Future<void> clearMood();

  UserModel? getSavedUserCredentials();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  HomeLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  @override
  String? getMood() {
    return _hiveService.getString(HiveKeyConstants.moodKey);
  }

  @override
  UserModel? getSavedUserCredentials() {
    return _hiveService.getObject<UserModel>(HiveKeyConstants.userKey);
  }

  @override
  Future<void> clearMood() async {
    await _hiveService.remove(HiveKeyConstants.moodKey);
  }
}
