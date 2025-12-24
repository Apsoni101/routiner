import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_model.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/data/data_source/remote_data_sources/profile_remote_data_source.dart';
import 'package:routiner/feature/profile/domain/repo/profile_remote_repo.dart';

class ProfileRemoteRepoImpl implements ProfileRemoteRepo {
  ProfileRemoteRepoImpl({required this.profileRemoteDataSource});

  final ProfileRemoteDataSource profileRemoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> getUserProfile(String uid) async {
    final Either<Failure, UserModel> result =
    await profileRemoteDataSource.getUserProfile(uid);

    return result.fold(
          Left<Failure, UserEntity>.new,
          Right<Failure, UserEntity>.new,
    );
  }

  @override
  Future<Either<Failure, Unit>> updateUserProfile(UserEntity profile) async {
    final userModel = UserModel(
      uid: profile.uid,
      email: profile.email,
      name: profile.name,
      surname: profile.surname,
      birthdate: profile.birthdate,
    );
    return profileRemoteDataSource.updateUserProfile(userModel);
  }
  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivities({int? limit}) async {
    final Either<Failure, List<ActivityModel>> result =
    await profileRemoteDataSource.getActivities(limit: limit);

    return result.fold(
      Left.new,
          (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, int>> getTotalPoints() {
    return profileRemoteDataSource.getTotalPoints();
  }
}