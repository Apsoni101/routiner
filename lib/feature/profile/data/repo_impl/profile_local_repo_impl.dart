// data/repositories/profile_local_repo_impl.dart
import 'package:dartz/dartz.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_hive_model.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/data/data_source/local_data_sources/profile_display_local_data_source.dart';
import 'package:routiner/feature/profile/domain/repo/profile_local_repo.dart';


class ProfileLocalRepoImpl implements ProfileLocalRepo {
  ProfileLocalRepoImpl({required this.profileLocalDataSource});

  final ProfileLocalDataSource profileLocalDataSource;

  @override
  UserEntity? getCachedProfile() {
    final userModel = profileLocalDataSource.getCachedProfile();
    return userModel;
  }

  @override
  Future<Unit> cacheProfile(UserEntity profile) async {
    final userModel = UserModel(
      uid: profile.uid,
      email: profile.email,
      name: profile.name,
      surname: profile.surname,
      birthdate: profile.birthdate,
    );
    return profileLocalDataSource.cacheProfile(userModel);
  }

  @override
  Future<Unit> clearCachedProfile() {
    return profileLocalDataSource.clearCachedProfile();
  }
  @override
  Future<List<ActivityEntity>> getActivities({int? limit}) async {
    final List<ActivityHiveModel> hiveModels =
    await profileLocalDataSource.getActivities(limit: limit);
    return hiveModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<int> getTotalPoints() {
    return profileLocalDataSource.getTotalPoints();
  }
}