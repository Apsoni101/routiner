// domain/repositories/profile_local_repo.dart
import 'package:dartz/dartz.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';

abstract class ProfileLocalRepo {
  UserEntity? getCachedProfile();
  Future<Unit> cacheProfile(UserEntity profile);
  Future<Unit> clearCachedProfile();
  Future<List<ActivityEntity>> getActivities({int? limit});
  Future<int> getTotalPoints();
}