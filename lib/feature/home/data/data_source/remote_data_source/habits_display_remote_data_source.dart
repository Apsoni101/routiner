import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/feature/challenge/data/model/challenge_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_model.dart';
import 'package:routiner/feature/home/data/model/habit_log_hive_model.dart';

/// Abstract habits list remote data source
abstract class HabitsDisplayRemoteDataSource {
  /// Save or update log for a specific habit & date
  Future<Either<Failure, Unit>> saveLog({
    required final String habitId,
    required final HabitLogHiveModel log,
  });

  /// Get log for a habit on a specific date
  Future<Either<Failure, HabitLogHiveModel?>> getLogForDate({
    required final String habitId,
    required final String date,
  });

  /// Get all logs for a habit
  Future<Either<Failure, List<HabitLogHiveModel>>> getLogsForHabit({
    required final String habitId,
  });

  /// Delete log for a habit on a specific date
  Future<Either<Failure, Unit>> deleteLog({
    required final String habitId,
    required final String date,
  });

  /// Get count of friends with the same goal name
  Future<Either<Failure, int>> getFriendsWithSameGoalCount({
    required final String habitName,
  });

  Future<Either<Failure, List<ChallengeModel>>> getAllChallenges();

  Future<Either<Failure, Unit>> saveActivity({
    required final ActivityModel activity,
  });

  Future<Either<Failure, int>> getTotalPoints();

  Future<Either<Failure, List<ActivityModel>>> getActivities({
    final int? limit,
  });
}

/// Implementation using Firestore
class HabitsDisplayRemoteDataSourceImpl
    implements HabitsDisplayRemoteDataSource {
  HabitsDisplayRemoteDataSourceImpl({
    required this.authService,
    required this.firestoreService,
  });

  final FirebaseAuthService authService;
  final FirebaseFirestoreService firestoreService;

  /// Path: users/{userId}/custom_habits/{habitId}/logs
  Future<Either<Failure, String>> _getLogsCollectionPath(
    final String habitId,
  ) async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();

    return userIdResult.fold(
      Left.new,
      (final String userId) =>
          Right('users/$userId/custom_habits/$habitId/logs'),
    );
  }

  /// Save / update log (docId = date)
  /// Uses SET instead of UPDATE to create or update
  @override
  Future<Either<Failure, Unit>> saveLog({
    required final String habitId,
    required final HabitLogHiveModel log,
  }) async {
    if (log.date == null || log.date!.isEmpty) {
      return const Left(Failure(message: 'Log date is required'));
    }

    final Either<Failure, String> pathResult = await _getLogsCollectionPath(
      habitId,
    );

    return pathResult.fold(Left.new, (final String path) {
      return firestoreService.request<Unit>(
        collectionPath: path,
        method: FirestoreMethod.set,
        docId: log.date,
        data: log.toJson(),
        responseParser: (_) => unit,
      );
    });
  }

  /// Get log for a specific habit & date
  @override
  Future<Either<Failure, HabitLogHiveModel?>> getLogForDate({
    required final String habitId,
    required final String date,
  }) async {
    final Either<Failure, String> pathResult = await _getLogsCollectionPath(
      habitId,
    );

    return pathResult.fold(Left.new, (final String path) async {
      final Either<Failure, Map<String, dynamic>?> result =
          await firestoreService.request<Map<String, dynamic>?>(
            collectionPath: path,
            method: FirestoreMethod.get,
            docId: date,
            responseParser: (final data) => data as Map<String, dynamic>?,
          );

      return result.fold(
        Left.new,
        (final Map<String, dynamic>? data) => data == null
            ? const Right(null)
            : Right(HabitLogHiveModel.fromJson(data)),
      );
    });
  }

  /// Get all logs for a habit
  @override
  Future<Either<Failure, List<HabitLogHiveModel>>> getLogsForHabit({
    required final String habitId,
  }) async {
    final Either<Failure, String> pathResult = await _getLogsCollectionPath(
      habitId,
    );

    return pathResult.fold(Left.new, (final String path) async {
      final Either<Failure, List<Map<String, dynamic>>> result =
          await firestoreService.request<List<Map<String, dynamic>>>(
            collectionPath: path,
            method: FirestoreMethod.getAll,
            responseParser: (final data) => data as List<Map<String, dynamic>>,
          );

      return result.fold(
        Left.new,
        (final List<Map<String, dynamic>> data) =>
            Right(data.map(HabitLogHiveModel.fromJson).toList()),
      );
    });
  }

  /// Delete log for a habit on a specific date
  @override
  Future<Either<Failure, Unit>> deleteLog({
    required final String habitId,
    required final String date,
  }) async {
    final Either<Failure, String> pathResult = await _getLogsCollectionPath(
      habitId,
    );

    return pathResult.fold(Left.new, (final String path) {
      return firestoreService.request<Unit>(
        collectionPath: path,
        method: FirestoreMethod.delete,
        docId: date,
        responseParser: (_) => unit,
      );
    });
  }

  @override
  Future<Either<Failure, int>> getFriendsWithSameGoalCount({
    required final String habitName,
  }) async {
    // First, get current user ID
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();

    return await currentUserIdResult.fold(Left.new, (
      final String currentUserId,
    ) async {
      // Get friend IDs for current user
      final Either<Failure, List<String>> friendIdsResult = await _getFriendIds(
        currentUserId,
      );

      return await friendIdsResult.fold(Left.new, (
        final List<String> friendIds,
      ) async {
        if (friendIds.isEmpty) {
          return const Right(0);
        }

        int matchingFriendsCount = 0;

        // Check each friend's habits
        for (final String friendId in friendIds) {
          final Either<Failure, List<Map<String, dynamic>>> result =
              await firestoreService.request<List<Map<String, dynamic>>>(
                collectionPath: 'users/$friendId/custom_habits',
                method: FirestoreMethod.getAll,
                responseParser: (final data) =>
                    data as List<Map<String, dynamic>>,
              );

          await result.fold(
            (final Failure _) async {
              // Skip this friend if we can't fetch their habits
            },
            (final List<Map<String, dynamic>> habits) async {
              // Check if any habit has the same name (case-insensitive)
              final bool hasMatchingHabit = habits.any((
                final Map<String, dynamic> habit,
              ) {
                final String? friendHabitName = habit['name']?.toString();
                return friendHabitName != null &&
                    friendHabitName.toLowerCase() == habitName.toLowerCase();
              });

              if (hasMatchingHabit) {
                matchingFriendsCount++;
              }
            },
          );
        }

        return Right(matchingFriendsCount);
      });
    });
  }

  /// Helper method to get friend IDs for a user
  Future<Either<Failure, List<String>>> _getFriendIds(
    final String userId,
  ) async {
    final Either<Failure, List<Map<String, dynamic>>> result =
        await firestoreService.request<List<Map<String, dynamic>>>(
          collectionPath: 'users/$userId/friends',
          method: FirestoreMethod.getAll,
          responseParser: (final data) => data as List<Map<String, dynamic>>,
        );

    return result.fold(Left.new, (final List<Map<String, dynamic>> data) {
      final List<String> friendIds = data
          .map((final Map<String, dynamic> json) => json['uid'] as String)
          .toList();
      return Right(friendIds);
    });
  }

  @override
  Future<Either<Failure, List<ChallengeModel>>> getAllChallenges() async {
    final Either<Failure, List<Map<String, dynamic>>> result =
        await firestoreService.request<List<Map<String, dynamic>>>(
          collectionPath: HiveKeyConstants.challengesCollection,
          method: FirestoreMethod.getAll,
          responseParser: (final data) => data as List<Map<String, dynamic>>,
        );

    return result.fold(Left.new, (final List<Map<String, dynamic>> data) {
      final List<ChallengeModel> challenges = data
          .map(ChallengeModel.fromJson)
          .where((final ChallengeModel c) => c.isActive ?? false)
          .toList();
      return Right(challenges);
    });
  }

  Future<Either<Failure, Unit>> saveActivity({
    required final ActivityModel activity,
  }) async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();

    return userIdResult.fold(Left.new, (final String userId) async {
      // 1. Add activity record
      final Either<Failure, Unit> activityResult = await firestoreService
          .request<Unit>(
            collectionPath: 'users/$userId/activities',
            method: FirestoreMethod.add,
            responseParser: (_) => unit,
            data: activity.toJson(),
          );

      return activityResult.fold(Left.new, (_) async {
        // 2. Get current points
        final Either<Failure, int> currentPointsResult = await getTotalPoints();

        return currentPointsResult.fold(Left.new, (
          final int currentPoints,
        ) async {
          // 3. Update total points
          return firestoreService.request<Unit>(
            collectionPath: 'users',
            method: FirestoreMethod.update,
            responseParser: (_) => unit,
            docId: userId,
            data: <String, dynamic>{
              'totalPoints': currentPoints + activity.points,
              'lastActivityTimestamp': activity.timestamp.toIso8601String(),
            },
          );
        });
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
}
