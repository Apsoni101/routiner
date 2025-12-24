
// domain/repositories/profile_remote_repo.dart
import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';

abstract class ProfileRemoteRepo {
  Future<Either<Failure, UserEntity>> getUserProfile(String uid);
  Future<Either<Failure, Unit>> updateUserProfile(UserEntity profile);
  Future<Either<Failure, List<ActivityEntity>>> getActivities({int? limit});
  Future<Either<Failure, int>> getTotalPoints();
}
