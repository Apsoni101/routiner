import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';

import 'package:routiner/core/services/network/failure.dart';
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
}
