
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/home/data/data_source/local_data_source/home_local_data_source.dart';
import 'package:routiner/feature/home/domain/repo/home_local_repo.dart';

class HomeLocalRepoImpl implements HomeLocalRepo {
  HomeLocalRepoImpl(this._localDataSource);

  final HomeLocalDataSource _localDataSource;

  @override
  String? getMood() {
    return _localDataSource.getMood();
  }

  @override
  Future<void> clearMood() async {
    await _localDataSource.clearMood();
  }

  @override
  UserEntity? getSavedUserCredentials() {
    final UserModel? userModel = _localDataSource.getSavedUserCredentials();
    return userModel;
  }
}
