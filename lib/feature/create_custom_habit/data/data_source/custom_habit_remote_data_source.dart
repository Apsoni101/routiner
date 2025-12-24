import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';

import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/data/model/activity_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_model.dart';

/// Abstract custom habit remote data source
abstract class CustomHabitRemoteDataSource {
  /// Save custom habit to Firestore
  Future<Either<Failure, String>> saveCustomHabit({
    required final CustomHabitModel habit,
  });

  /// Get all custom habits for a user
  Future<Either<Failure, List<CustomHabitModel>>> getCustomHabits();

  /// Get a single custom habit by ID
  Future<Either<Failure, CustomHabitModel>> getCustomHabit({
    required final String habitId,
  });

  /// Update custom habit
  Future<Either<Failure, Unit>> updateCustomHabit({
    required final CustomHabitModel habit,
  });

  /// Delete custom habit
  Future<Either<Failure, Unit>> deleteCustomHabit({
    required final String habitId,
  });

  /// Check if a custom habit exists
  Future<Either<Failure, bool>> habitExists({required final String habitId});

  Future<Either<Failure, Unit>> saveActivity({
    required final ActivityModel activity,
  });

  Future<Either<Failure, int>> getTotalPoints();

  Future<Either<Failure, List<ActivityModel>>> getActivities({final int? limit});
}

/// Implementation of custom habit remote data source using Firestore
class CustomHabitRemoteDataSourceImpl implements CustomHabitRemoteDataSource {
  CustomHabitRemoteDataSourceImpl({
    required this.authService,
    required this.firestoreService,
  });

  final FirebaseAuthService authService;
  final FirebaseFirestoreService firestoreService;

  /// Get collection path for current user
  Future<Either<Failure, String>> _getCollectionPath() async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();
    return userIdResult.fold(
      Left<Failure, String>.new,
      (final String userId) =>
          Right<Failure, String>('users/$userId/custom_habits'),
    );
  }

  @override
  Future<Either<Failure, String>> saveCustomHabit({
    required final CustomHabitModel habit,
  }) async {
    final Either<Failure, String> collectionPathResult =
        await _getCollectionPath();

    return collectionPathResult.fold(Left<Failure, String>.new, (
      final String collectionPath,
    ) async {
      if (habit.id != null && habit.id!.isNotEmpty) {
        // Update existing habit using set
        final Either<Failure, Unit> result = await firestoreService
            .request<Unit>(
              collectionPath: collectionPath,
              method: FirestoreMethod.set,
              responseParser: (final dynamic _) => unit,
              docId: habit.id,
              data: habit.toJson(),
            );

        return result.fold(
          Left<Failure, String>.new,
          (final Unit _) => Right<Failure, String>(habit.id!),
        );
      } else {
        // Add new habit
        return firestoreService.request<String>(
          collectionPath: collectionPath,
          method: FirestoreMethod.add,
          responseParser: (final dynamic id) => id as String,
          data: habit.toJson(),
        );
      }
    });
  }

  @override
  Future<Either<Failure, List<CustomHabitModel>>> getCustomHabits() async {
    final Either<Failure, String> collectionPathResult =
        await _getCollectionPath();

    return collectionPathResult.fold(
      Left<Failure, List<CustomHabitModel>>.new,
      (final String collectionPath) async {
        final Either<Failure, List<Map<String, dynamic>>> result =
            await firestoreService.request<List<Map<String, dynamic>>>(
              collectionPath: collectionPath,
              method: FirestoreMethod.getAll,
              responseParser: (final dynamic data) =>
                  data as List<Map<String, dynamic>>,
            );

        return result.fold(Left<Failure, List<CustomHabitModel>>.new, (
          final List<Map<String, dynamic>> data,
        ) {
          final List<CustomHabitModel> habits = data
              .map(CustomHabitModel.fromJson)
              .toList();
          return Right<Failure, List<CustomHabitModel>>(habits);
        });
      },
    );
  }

  @override
  Future<Either<Failure, CustomHabitModel>> getCustomHabit({
    required final String habitId,
  }) async {
    final Either<Failure, String> collectionPathResult =
        await _getCollectionPath();

    return collectionPathResult.fold(Left<Failure, CustomHabitModel>.new, (
      final String collectionPath,
    ) async {
      final Either<Failure, Map<String, dynamic>> result =
          await firestoreService.request<Map<String, dynamic>>(
            collectionPath: collectionPath,
            method: FirestoreMethod.get,
            responseParser: (final dynamic data) =>
                data as Map<String, dynamic>,
            docId: habitId,
          );

      return result.fold(Left<Failure, CustomHabitModel>.new, (
        final Map<String, dynamic> data,
      ) {
        final CustomHabitModel habit = CustomHabitModel.fromJson(data);
        return Right<Failure, CustomHabitModel>(habit);
      });
    });
  }

  @override
  Future<Either<Failure, Unit>> updateCustomHabit({
    required final CustomHabitModel habit,
  }) async {
    if (habit.id == null || habit.id!.isEmpty) {
      return const Left<Failure, Unit>(
        Failure(message: 'Habit ID is required for update'),
      );
    }

    final Either<Failure, String> collectionPathResult =
        await _getCollectionPath();

    return collectionPathResult.fold(Left<Failure, Unit>.new, (
      final String collectionPath,
    ) async {
      return firestoreService.request<Unit>(
        collectionPath: collectionPath,
        method: FirestoreMethod.update,
        responseParser: (final dynamic _) => unit,
        docId: habit.id,
        data: habit.toJson(),
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteCustomHabit({
    required final String habitId,
  }) async {
    final Either<Failure, String> collectionPathResult =
        await _getCollectionPath();

    return collectionPathResult.fold(Left<Failure, Unit>.new, (
      final String collectionPath,
    ) async {
      return firestoreService.request<Unit>(
        collectionPath: collectionPath,
        method: FirestoreMethod.delete,
        responseParser: (final dynamic _) => unit,
        docId: habitId,
      );
    });
  }

  @override
  Future<Either<Failure, bool>> habitExists({
    required final String habitId,
  }) async {
    final Either<Failure, String> collectionPathResult =
        await _getCollectionPath();

    return collectionPathResult.fold(Left<Failure, bool>.new, (
      final String collectionPath,
    ) async {
      return firestoreService.request<bool>(
        collectionPath: collectionPath,
        method: FirestoreMethod.exists,
        responseParser: (final dynamic exists) => exists as bool,
        docId: habitId,
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> saveActivity({
    required final ActivityModel activity,
  }) async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();

    return userIdResult.fold(Left.new, (final String userId) async {
      // 1. Add activity record to activities collection
      final Either<Failure, Unit> activityResult = await firestoreService
          .request<Unit>(
            collectionPath: 'users/$userId/activities',
            method: FirestoreMethod.add,
            responseParser: (_) => unit,
            data: activity.toJson(),
          );

      return activityResult.fold(Left.new, (_) async {
        // 2. Get current total points
        final Either<Failure, int> currentPointsResult = await getTotalPoints();

        return currentPointsResult.fold(Left.new, (final int currentPoints) async {
          // 3. Update user's total points
          final Either<Failure, Unit> pointsResult = await firestoreService
              .request<Unit>(
                collectionPath: 'users',
                method: FirestoreMethod.update,
                responseParser: (_) => unit,
                docId: userId,
                data: <String, dynamic>{
                  'totalPoints': currentPoints + activity.points,
                  'lastActivityTimestamp': activity.timestamp.toIso8601String(),
                },
              );

          return pointsResult;
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
        List<ActivityModel> activities = data
            .map(ActivityModel.fromJson)
            .toList()

        // Sort by timestamp descending
        ..sort((final ActivityModel a, final ActivityModel b) => b.timestamp.compareTo(a.timestamp));

        // Apply limit if specified
        if (limit != null && activities.length > limit) {
          activities = activities.sublist(0, limit);
        }

        return Right(activities);
      });
    });
  }
}
