// data/data_sources/profile_remote_data_source.dart
import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserModel>> getUserProfile(String uid);
  Future<Either<Failure, Unit>> updateUserProfile(UserModel profile);
  Future<Either<Failure, List<ActivityModel>>> getActivities({int? limit});
  Future<Either<Failure, int>> getTotalPoints();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({
    required this.firestoreService,
    required this.authService,
  });

  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService authService;

  @override
  Future<Either<Failure, UserModel>> getUserProfile(String uid) async {
    final Either<Failure, Map<String, dynamic>> result =
    await firestoreService.request<Map<String, dynamic>>(
      collectionPath: 'users',
      method: FirestoreMethod.get,
      responseParser: (final data) => data as Map<String, dynamic>,
      docId: uid,
    );

    return result.fold(
          (final Failure failure) => Left<Failure, UserModel>(failure),
          (final Map<String, dynamic> data) {
        try {
          final UserModel profile = UserModel.fromFirestore(data: data);
          return Right<Failure, UserModel>(profile);
        } catch (e) {
          return Left<Failure, UserModel>(
            Failure(message: 'Failed to parse profile data: $e'),
          );
        }
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> updateUserProfile(UserModel profile) async {
    final Either<Failure, Unit> result =
    await firestoreService.request<Unit>(
      collectionPath: 'users',
      method: FirestoreMethod.set,
      responseParser: (final _) => unit,
      docId: profile.uid,
      data: profile.toJson(),
    );

    return result;
  }
  @override
  Future<Either<Failure, List<ActivityModel>>> getActivities({int? limit}) async {
    final Either<Failure, String> userIdResult = await authService.getCurrentUserId();

    return userIdResult.fold(
      Left.new,
          (final String userId) async {
        final Either<Failure, List<Map<String, dynamic>>> result =
        await firestoreService.request<List<Map<String, dynamic>>>(
          collectionPath: 'users/$userId/activities',
          method: FirestoreMethod.getAll,
          responseParser: (data) => data as List<Map<String, dynamic>>,
        );

        return result.fold(
          Left.new,
              (final List<Map<String, dynamic>> data) {
            var activities = data.map((json) => ActivityModel.fromJson(json)).toList();

            // Sort by timestamp descending
            activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            if (limit != null && activities.length > limit) {
              activities = activities.sublist(0, limit);
            }

            return Right(activities);
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, int>> getTotalPoints() async {
    final Either<Failure, String> userIdResult = await authService.getCurrentUserId();

    return userIdResult.fold(
      Left.new,
          (final String userId) async {
        final Either<Failure, Map<String, dynamic>> result =
        await firestoreService.request<Map<String, dynamic>>(
          collectionPath: 'users',
          method: FirestoreMethod.get,
          responseParser: (data) => data as Map<String, dynamic>,
          docId: userId,
        );

        return result.fold(
          Left.new,
              (final Map<String, dynamic> data) {
            final int points = data['totalPoints'] as int? ?? 0;
            return Right(points);
          },
        );
      },
    );
  }
}
