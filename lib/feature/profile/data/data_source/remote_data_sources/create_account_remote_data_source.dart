import 'package:dartz/dartz.dart';
import 'package:routiner/core/enums/genders.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_model.dart';

abstract class CreateAccountRemoteDataSource {
  Future<Either<Failure, Unit>> saveAccountData({
    required final Gender gender,
    required final List<CustomHabitModel> habits,
  });

  Future<Either<Failure, Map<String, dynamic>>> getAccountData();

  Future<Either<Failure, Unit>> updateGender({required final Gender gender});
}

class CreateAccountRemoteDataSourceImpl
    implements CreateAccountRemoteDataSource {
  CreateAccountRemoteDataSourceImpl({
    required this.authService,
    required this.firestoreService,
  });

  final FirebaseAuthService authService;
  final FirebaseFirestoreService firestoreService;

  Future<Either<Failure, String>> _getUserDocPath() async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();
    return userIdResult.fold(
      Left<Failure, String>.new,
      (final String userId) => Right<Failure, String>('users/$userId'),
    );
  }

  Future<Either<Failure, String>> _getCustomHabitsCollectionPath() async {
    final Either<Failure, String> userIdResult = await authService
        .getCurrentUserId();
    return userIdResult.fold(
      Left<Failure, String>.new,
      (final String userId) =>
          Right<Failure, String>('users/$userId/custom_habits'),
    );
  }

  @override
  Future<Either<Failure, Unit>> saveAccountData({
    required final Gender gender,
    required final List<CustomHabitModel> habits,
  }) async {
    final Either<Failure, String> userDocPathResult = await _getUserDocPath();

    final Either<Failure, Unit> genderResult = await userDocPathResult
        .fold<Future<Either<Failure, Unit>>>(
          (final Failure failure) async => Left<Failure, Unit>(failure),
          (final String userDocPath) async {
            final String userId = userDocPath.split('/').last;

            // ✅ FIX: Use FirestoreMethod.merge to preserve existing user data
            return firestoreService.request<Unit>(
              collectionPath: 'users',
              method: FirestoreMethod.merge,
              // ← Changed from .set to .merge
              responseParser: (final dynamic _) => unit,
              docId: userId,
              data: <String, dynamic>{
                'gender': gender.name,
                'createdAt': DateTime.now().toIso8601String(),
              },
            );
          },
        );

    if (genderResult.isLeft()) {
      return genderResult;
    }

    final Either<Failure, String> habitsCollectionPathResult =
        await _getCustomHabitsCollectionPath();

    return habitsCollectionPathResult.fold<Future<Either<Failure, Unit>>>(
      (final Failure failure) async => Left<Failure, Unit>(failure),
      (final String collectionPath) async {
        for (final CustomHabitModel habit in habits) {
          if (habit.id == null || habit.id!.isEmpty) {
            return const Left<Failure, Unit>(
              Failure(message: 'Habit ID is required'),
            );
          }

          final Either<Failure, Unit> result = await firestoreService
              .request<Unit>(
                collectionPath: collectionPath,
                method: FirestoreMethod.set,
                docId: habit.id,
                responseParser: (final dynamic _) => unit,
                data: habit.toJson(),
              );

          if (result.isLeft()) {
            return result;
          }
        }

        return const Right<Failure, Unit>(unit);
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAccountData() async {
    final Either<Failure, String> userDocPathResult = await _getUserDocPath();

    return userDocPathResult
        .fold<Future<Either<Failure, Map<String, dynamic>>>>(
          (final Failure failure) async =>
              Left<Failure, Map<String, dynamic>>(failure),
          (final String userDocPath) async {
            return firestoreService.request<Map<String, dynamic>>(
              collectionPath: 'users',
              method: FirestoreMethod.get,
              responseParser: (final dynamic data) =>
                  data as Map<String, dynamic>,
              docId: userDocPath.split('/').last,
            );
          },
        );
  }

  @override
  Future<Either<Failure, Unit>> updateGender({
    required final Gender gender,
  }) async {
    final Either<Failure, String> userDocPathResult = await _getUserDocPath();

    return userDocPathResult.fold<Future<Either<Failure, Unit>>>(
      (final Failure failure) async => Left<Failure, Unit>(failure),
      (final String userDocPath) async {
        // ✅ Already using FirestoreMethod.update which merges by default
        return firestoreService.request<Unit>(
          collectionPath: 'users',
          method: FirestoreMethod.update,
          responseParser: (final dynamic _) => unit,
          docId: userDocPath.split('/').last,
          data: <String, dynamic>{
            'gender': gender.name,
            'updatedAt': DateTime.now().toIso8601String(),
          },
        );
      },
    );
  }
}
