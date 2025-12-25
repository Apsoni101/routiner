import 'package:dartz/dartz.dart';
import 'package:routiner/core/enums/achievement_definitions.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_model.dart';
import 'package:routiner/feature/profile/data/model/achievement_model.dart';
import 'package:routiner/feature/profile/domain/entity/achievement_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserModel>> getUserProfile(final String uid);

  Future<Either<Failure, Unit>> updateUserProfile(final UserModel profile);

  Future<Either<Failure, List<ActivityModel>>> getActivities({
    final int? limit,
  });

  Future<Either<Failure, int>> getTotalPoints();

  Future<Either<Failure, List<AchievementModel>>> getAchievements();

  Future<Either<Failure, Unit>> updateAchievement(
    final AchievementModel achievement,
  );

  Future<Either<Failure, Unit>> unlockAchievement(final String achievementId);

  Future<Either<Failure, Unit>> initializeAchievements();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({
    required this.firestoreService,
    required this.authService,
  });

  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService authService;

  @override
  Future<Either<Failure, UserModel>> getUserProfile(final String uid) async {
    final Either<Failure, Map<String, dynamic>> result = await firestoreService
        .request<Map<String, dynamic>>(
          collectionPath: 'users',
          method: FirestoreMethod.get,
          responseParser: (final data) => data as Map<String, dynamic>,
          docId: uid,
        );

    return result.fold(Left<Failure, UserModel>.new, (
      final Map<String, dynamic> data,
    ) {
      try {
        final UserModel profile = UserModel.fromFirestore(data: data);
        return Right<Failure, UserModel>(profile);
      } catch (e) {
        return Left<Failure, UserModel>(
          Failure(message: 'Failed to parse profile data: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> updateUserProfile(
    final UserModel profile,
  ) async {
    final Either<Failure, Unit> result = await firestoreService.request<Unit>(
      collectionPath: 'users',
      method: FirestoreMethod.set,
      responseParser: (final _) => unit,
      docId: profile.uid,
      data: profile.toJson(),
    );

    return result;
  }

  @override
  Future<Either<Failure, List<ActivityModel>>> getActivities({
    final int? limit,
  }) async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();

    return userIdResult.fold(Left.new, (final String userId) async {
      final Either<Failure, List<Map<String, dynamic>>> result =
          await firestoreService.request<List<Map<String, dynamic>>>(
            collectionPath: 'users/$userId/activities',
            method: FirestoreMethod.getAll,
            responseParser: (final data) => data as List<Map<String, dynamic>>,
          );

      return result.fold(Left.new, (final List<Map<String, dynamic>> data) {
        List<ActivityModel> activities =
            data.map(ActivityModel.fromJson).toList()..sort(
              (final ActivityModel a, final ActivityModel b) =>
                  b.timestamp.compareTo(a.timestamp),
            );

        if (limit != null && activities.length > limit) {
          activities = activities.sublist(0, limit);
        }

        return Right(activities);
      });
    });
  }

  @override
  Future<Either<Failure, int>> getTotalPoints() async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();

    return userIdResult.fold(Left.new, (final String userId) async {
      final Either<Failure, Map<String, dynamic>> result =
          await firestoreService.request<Map<String, dynamic>>(
            collectionPath: 'users',
            method: FirestoreMethod.get,
            responseParser: (final data) => data as Map<String, dynamic>,
            docId: userId,
          );

      return result.fold(Left.new, (final Map<String, dynamic> data) {
        final int points = data['totalPoints'] as int? ?? 0;
        return Right(points);
      });
    });
  }

  @override
  Future<Either<Failure, List<AchievementModel>>> getAchievements() async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();

    return userIdResult.fold(Left.new, (final String userId) async {
      final Either<Failure, List<Map<String, dynamic>>> result =
          await firestoreService.request<List<Map<String, dynamic>>>(
            collectionPath: 'users/$userId/achievements',
            method: FirestoreMethod.getAll,
            responseParser: (final data) => data as List<Map<String, dynamic>>,
          );

      return result.fold(Left.new, (final List<Map<String, dynamic>> data) {
        final List<AchievementModel> achievements = data
            .map(AchievementModel.fromJson)
            .toList();
        return Right(achievements);
      });
    });
  }

  @override
  Future<Either<Failure, Unit>> updateAchievement(
    final AchievementModel achievement,
  ) async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();

    return userIdResult.fold(Left.new, (final String userId) async {
      return firestoreService.request<Unit>(
        collectionPath: 'users/$userId/achievements',
        method: FirestoreMethod.set,
        responseParser: (_) => unit,
        docId: achievement.id,
        data: achievement.toJson(),
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> unlockAchievement(
    final String achievementId,
  ) async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();

    return userIdResult.fold(Left.new, (final String userId) async {
      return firestoreService.request<Unit>(
        collectionPath: 'users/$userId/achievements',
        method: FirestoreMethod.update,
        responseParser: (_) => unit,
        docId: achievementId,
        data: <String, dynamic>{
          'isUnlocked': true,
          'unlockedAt': DateTime.now().toIso8601String(),
        },
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> initializeAchievements() async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();

    return userIdResult.fold(Left.new, (final String userId) async {
      final Either<Failure, List<Map<String, dynamic>>> existingResult =
          await firestoreService.request<List<Map<String, dynamic>>>(
            collectionPath: 'users/$userId/achievements',
            method: FirestoreMethod.getAll,
            responseParser: (final data) => data as List<Map<String, dynamic>>,
          );

      return existingResult.fold(
        (final Failure failure) async {
          final List<AchievementEntity> defaultAchievements =
              AchievementDefinition.getAllAsEntities();

          for (final AchievementEntity achievement in defaultAchievements) {
            final AchievementModel model = AchievementModel.fromEntity(
              achievement,
            );
            await firestoreService.request<Unit>(
              collectionPath: 'users/$userId/achievements',
              method: FirestoreMethod.set,
              responseParser: (_) => unit,
              docId: achievement.id,
              data: model.toJson(),
            );
          }

          return const Right(unit);
        },

        (final List<Map<String, dynamic>> existingData) async {
          if (existingData.isEmpty) {
            final List<AchievementEntity> defaultAchievements =
                AchievementDefinition.getAllAsEntities();

            for (final AchievementEntity achievement in defaultAchievements) {
              final AchievementModel model = AchievementModel.fromEntity(
                achievement,
              );
              await firestoreService.request<Unit>(
                collectionPath: 'users/$userId/achievements',
                method: FirestoreMethod.set,
                responseParser: (_) => unit,
                docId: achievement.id,
                data: model.toJson(),
              );
            }
          } else {
            final Set<String> existingIds = existingData
                .map((final Map<String, dynamic> e) => e['id'] as String)
                .toSet();

            final List<AchievementEntity> defaultAchievements =
                AchievementDefinition.getAllAsEntities();
            final List<AchievementEntity> newAchievements = defaultAchievements
                .where(
                  (final AchievementEntity a) => !existingIds.contains(a.id),
                )
                .toList();

            for (final AchievementEntity achievement in newAchievements) {
              final AchievementModel model = AchievementModel.fromEntity(
                achievement,
              );
              await firestoreService.request<Unit>(
                collectionPath: 'users/$userId/achievements',
                method: FirestoreMethod.set,
                responseParser: (_) => unit,
                docId: achievement.id,
                data: model.toJson(),
              );
            }
          }

          return const Right(unit);
        },
      );
    });
  }
}
