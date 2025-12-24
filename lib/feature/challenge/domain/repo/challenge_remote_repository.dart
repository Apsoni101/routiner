import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

abstract class ChallengeRemoteRepository {
  Future<Either<Failure, String>> getCurrentUserId();

  Future<Either<Failure, String>> createChallenge(
      final ChallengeEntity challenge,
      );

  Future<Either<Failure, List<ChallengeEntity>>> getAllChallenges();

  Future<Either<Failure, ChallengeEntity>> getChallengeById(
      final String challengeId,
      );

  Future<Either<Failure, Unit>> updateChallenge(
      final ChallengeEntity challenge,
      );

  Future<Either<Failure, Unit>> deleteChallenge(final String challengeId);

  Future<Either<Failure, int>> getFriendsInChallengeCount(
      final String challengeId,
      );

  Future<Either<Failure, List<CustomHabitEntity>>> getUserHabits();

  Future<Either<Failure, CustomHabitEntity>> getHabitById(
      final String habitId,
      );

  Future<Either<Failure, String>> saveHabit(final CustomHabitEntity habit);

  Future<Either<Failure, Unit>> deleteHabit(final String habitId);

  Future<Either<Failure, List<HabitLogEntity>>> getHabitLogsByDateRange({
    required final String habitId,
    required final DateTime startDate,
    required final DateTime endDate,
  });

  // NEW: Save habit log
  Future<Either<Failure, Unit>> saveHabitLog({
    required final String habitId,
    required final HabitLogEntity log,
  });

  // NEW: Get friends with same goal count
  Future<Either<Failure, int>> getFriendsWithSameGoalCount({
    required final String habitName,
  });

  Future<Either<Failure, String>> saveChallengeHabit({
    required final CustomHabitEntity habit,
  });
}