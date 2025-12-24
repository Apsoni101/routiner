import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/core/services/storage/hive_key_constants.dart';
import 'package:routiner/feature/challenge/data/model/challenge_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_model.dart';
import 'package:routiner/feature/home/data/model/habit_log_hive_model.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

abstract class ChallengeRemoteDataSource {
  Future<Either<Failure, String>> getCurrentUserId();

  Future<Either<Failure, String>> createChallenge({
    required final ChallengeModel challenge,
  });

  Future<Either<Failure, List<ChallengeModel>>> getAllChallenges();

  Future<Either<Failure, ChallengeModel>> getChallengeById({
    required final String challengeId,
  });

  Future<Either<Failure, Unit>> updateChallenge({
    required final ChallengeModel challenge,
  });

  Future<Either<Failure, Unit>> deleteChallenge({
    required final String challengeId,
  });

  Future<Either<Failure, int>> getFriendsInChallengeCount({
    required final String challengeId,
  });

  Future<Either<Failure, List<CustomHabitModel>>> getUserHabits();

  Future<Either<Failure, CustomHabitModel>> getHabitById({
    required final String habitId,
  });

  Future<Either<Failure, String>> saveHabit({
    required final CustomHabitModel habit,
  });

  Future<Either<Failure, Unit>> deleteHabit({required final String habitId});

  Future<Either<Failure, List<HabitLogEntity>>> getHabitLogsByDateRange({
    required String habitId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Either<Failure, Unit>> saveHabitLog({
    required final String habitId,
    required final HabitLogHiveModel log,
  });

  Future<Either<Failure, int>> getFriendsWithSameGoalCount({
    required final String habitName,
  });

  // NEW: Save habit to global collection
  Future<Either<Failure, String>> saveChallengeHabit({
    required final CustomHabitModel habit,
  });
}

class ChallengeRemoteDataSourceImpl implements ChallengeRemoteDataSource {
  ChallengeRemoteDataSourceImpl({
    required this.authService,
    required this.firestoreService,
  });

  final FirebaseAuthService authService;
  final FirebaseFirestoreService firestoreService;

  // Global collection path for challenge habits
  static const String _challengeHabitsCollection = 'challenge_habits';

  @override
  Future<Either<Failure, String>> getCurrentUserId() {
    return _getUserId();
  }

  Future<Either<Failure, String>> _getUserId() async {
    return authService.getCurrentUserId();
  }

  Future<Either<Failure, String>> _getUserHabitsPath() async {
    final Either<Failure, String> userIdResult = await _getUserId();
    return userIdResult.fold(
      Left.new,
          (final String userId) => Right('users/$userId/custom_habits'),
    );
  }

  Future<Either<Failure, String>> _getLogsCollectionPath(
      final String habitId,
      ) async {
    final Either<Failure, String> userIdResult = await _getUserId();

    return userIdResult.fold(
      Left.new,
          (final String userId) =>
          Right('users/$userId/custom_habits/$habitId/logs'),
    );
  }

  @override
  Future<Either<Failure, String>> createChallenge({
    required final ChallengeModel challenge,
  }) async {
    // First, save all habits to global challenge_habits collection
    if (challenge.habitIds != null && challenge.habitIds!.isNotEmpty) {
      for (final String habitId in challenge.habitIds!) {
        // Get habit from user's collection
        final Either<Failure, CustomHabitModel> habitResult =
        await getHabitById(habitId: habitId);

        await habitResult.fold(
              (failure) async {
            // Log error but continue
            print('[ChallengeRemoteDataSource] Failed to get habit $habitId: ${failure.message}');
          },
              (habit) async {
            // Save to global collection
            await saveChallengeHabit(habit: habit);
          },
        );
      }
    }

    // Then create the challenge
    return firestoreService.request<String>(
      collectionPath: HiveKeyConstants.challengesCollection,
      method: FirestoreMethod.set,
      docId: challenge.id,
      responseParser: (final data) => challenge.id!,
      data: challenge.toJson(),
    );
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

  @override
  Future<Either<Failure, ChallengeModel>> getChallengeById({
    required final String challengeId,
  }) async {
    final Either<Failure, Map<String, dynamic>> result = await firestoreService
        .request<Map<String, dynamic>>(
      collectionPath: HiveKeyConstants.challengesCollection,
      method: FirestoreMethod.get,
      responseParser: (final data) => data as Map<String, dynamic>,
      docId: challengeId,
    );

    return result.fold(
      Left.new,
          (final Map<String, dynamic> data) =>
          Right(ChallengeModel.fromJson(data)),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateChallenge({
    required final ChallengeModel challenge,
  }) async {
    if (challenge.id == null || challenge.id!.isEmpty) {
      return const Left(Failure(message: 'Challenge ID is required'));
    }

    return firestoreService.request<Unit>(
      collectionPath: HiveKeyConstants.challengesCollection,
      method: FirestoreMethod.update,
      responseParser: (_) => unit,
      docId: challenge.id,
      data: challenge.toJson(),
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteChallenge({
    required final String challengeId,
  }) async {
    return firestoreService.request<Unit>(
      collectionPath: HiveKeyConstants.challengesCollection,
      method: FirestoreMethod.delete,
      responseParser: (_) => unit,
      docId: challengeId,
    );
  }

  @override
  Future<Either<Failure, int>> getFriendsInChallengeCount({
    required final String challengeId,
  }) async {
    final Either<Failure, String> userIdResult = await _getUserId();

    return await userIdResult.fold(Left.new, (final String userId) async {
      final Either<Failure, List<String>> friendIdsResult = await _getFriendIds(
        userId,
      );

      return await friendIdsResult.fold(Left.new, (
          final List<String> friendIds,
          ) async {
        final Either<Failure, ChallengeModel> challengeResult =
        await getChallengeById(challengeId: challengeId);

        return challengeResult.fold(Left.new, (final ChallengeModel challenge) {
          final List<String> participantsList =
              challenge.participantIds ?? <String>[];
          final int friendsInChallenge = friendIds
              .where(participantsList.contains)
              .length;
          return Right(friendsInChallenge);
        });
      });
    });
  }

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
  Future<Either<Failure, List<CustomHabitModel>>> getUserHabits() async {
    final Either<Failure, String> pathResult = await _getUserHabitsPath();

    return await pathResult.fold(Left.new, (final String path) async {
      final Either<Failure, List<Map<String, dynamic>>> result =
      await firestoreService.request<List<Map<String, dynamic>>>(
        collectionPath: path,
        method: FirestoreMethod.getAll,
        responseParser: (final data) => data as List<Map<String, dynamic>>,
      );

      return result.fold(Left.new, (final List<Map<String, dynamic>> data) {
        final List<CustomHabitModel> habits = data
            .map(CustomHabitModel.fromJson)
            .toList();
        return Right(habits);
      });
    });
  }

  @override
  Future<Either<Failure, CustomHabitModel>> getHabitById({
    required final String habitId,
  }) async {
    // Try user's habits first
    final Either<Failure, String> pathResult = await _getUserHabitsPath();

    return await pathResult.fold(Left.new, (final String path) async {
      final Either<Failure, Map<String, dynamic>> userHabitResult =
      await firestoreService.request<Map<String, dynamic>>(
        collectionPath: path,
        method: FirestoreMethod.get,
        responseParser: (final data) => data as Map<String, dynamic>,
        docId: habitId,
      );

      // If found in user's habits, return it
      return await userHabitResult.fold(
            (userFailure) async {
          // Not found in user's habits, try global challenge_habits collection
          print('[ChallengeRemoteDataSource] Habit $habitId not found in user habits, checking global collection');

          final Either<Failure, Map<String, dynamic>> globalHabitResult =
          await firestoreService.request<Map<String, dynamic>>(
            collectionPath: _challengeHabitsCollection,
            method: FirestoreMethod.get,
            responseParser: (final data) => data as Map<String, dynamic>,
            docId: habitId,
          );

          return globalHabitResult.fold(
                (globalFailure) {
              // Not found in either location
              print('[ChallengeRemoteDataSource] Habit $habitId not found in global collection either');
              return Left(globalFailure);
            },
                (final Map<String, dynamic> data) {
              print('[ChallengeRemoteDataSource] Habit $habitId found in global collection');
              return Right(CustomHabitModel.fromJson(data));
            },
          );
        },
            (final Map<String, dynamic> data) {
          print('[ChallengeRemoteDataSource] Habit $habitId found in user habits');
          return Right(CustomHabitModel.fromJson(data));
        },
      );
    });
  }

  @override
  Future<Either<Failure, String>> saveHabit({
    required final CustomHabitModel habit,
  }) async {
    final Either<Failure, String> pathResult = await _getUserHabitsPath();

    return await pathResult.fold(Left.new, (final String path) async {
      if (habit.id != null && habit.id!.isNotEmpty) {
        final Either<Failure, Unit> result = await firestoreService
            .request<Unit>(
          collectionPath: path,
          method: FirestoreMethod.set,
          responseParser: (_) => unit,
          docId: habit.id,
          data: habit.toJson(),
        );

        return result.fold(Left.new, (_) => Right(habit.id!));
      } else {
        return firestoreService.request<String>(
          collectionPath: path,
          method: FirestoreMethod.add,
          responseParser: (final id) => id as String,
          data: habit.toJson(),
        );
      }
    });
  }

  @override
  Future<Either<Failure, String>> saveChallengeHabit({
    required final CustomHabitModel habit,
  }) async {
    if (habit.id == null || habit.id!.isEmpty) {
      return const Left(Failure(message: 'Habit ID is required for challenge habits'));
    }

    print('[ChallengeRemoteDataSource] Saving habit ${habit.id} to global collection');

    final Either<Failure, Unit> result = await firestoreService.request<Unit>(
      collectionPath: _challengeHabitsCollection,
      method: FirestoreMethod.set,
      responseParser: (_) => unit,
      docId: habit.id,
      data: habit.toJson(),
    );

    return result.fold(
          (failure) {
        print('[ChallengeRemoteDataSource] Failed to save habit to global collection: ${failure.message}');
        return Left(failure);
      },
          (_) {
        print('[ChallengeRemoteDataSource] Habit ${habit.id} saved to global collection successfully');
        return Right(habit.id!);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteHabit({
    required final String habitId,
  }) async {
    final Either<Failure, String> pathResult = await _getUserHabitsPath();

    return await pathResult.fold(Left.new, (final String path) {
      return firestoreService.request<Unit>(
        collectionPath: path,
        method: FirestoreMethod.delete,
        responseParser: (_) => unit,
        docId: habitId,
      );
    });
  }

  @override
  Future<Either<Failure, List<HabitLogEntity>>> getHabitLogsByDateRange({
    required String habitId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Either<Failure, String> pathResult = await _getLogsCollectionPath(habitId);

    return await pathResult.fold(Left.new, (final String path) async {
      final Either<Failure, List<Map<String, dynamic>>> result =
      await firestoreService.request<List<Map<String, dynamic>>>(
        collectionPath: path,
        method: FirestoreMethod.getAll,
        responseParser: (final data) => data as List<Map<String, dynamic>>,
      );

      return result.fold(Left.new, (final List<Map<String, dynamic>> data) {
        final List<HabitLogEntity> logs = data
            .map((json) => HabitLogHiveModel.fromJson(json).toEntity())
            .where((log) {
          return log.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              log.date.isBefore(endDate.add(const Duration(days: 1)));
        })
            .toList();
        return Right(logs);
      });
    });
  }

  @override
  Future<Either<Failure, Unit>> saveHabitLog({
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

  @override
  Future<Either<Failure, int>> getFriendsWithSameGoalCount({
    required final String habitName,
  }) async {
    final Either<Failure, String> currentUserIdResult = await _getUserId();

    return await currentUserIdResult.fold(Left.new, (
        final String currentUserId,
        ) async {
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
}