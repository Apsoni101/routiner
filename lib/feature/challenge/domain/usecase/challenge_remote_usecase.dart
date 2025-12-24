import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/domain/repo/challenge_remote_repository.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

class ChallengeRemoteUsecase {
  ChallengeRemoteUsecase(this._repository);

  final ChallengeRemoteRepository _repository;

  Future<Either<Failure, String>> getCurrentUserId() {
    return _repository.getCurrentUserId();
  }

  Future<Either<Failure, String>> createChallenge(
      final ChallengeEntity challenge,
      ) {
    return _repository.createChallenge(challenge);
  }

  Future<Either<Failure, List<ChallengeEntity>>> getAllChallenges() {
    return _repository.getAllChallenges();
  }

  Future<Either<Failure, ChallengeEntity>> getChallengeById(
      final String challengeId,
      ) {
    return _repository.getChallengeById(challengeId);
  }

  Future<Either<Failure, Unit>> updateChallenge(
      final ChallengeEntity challenge,
      ) {
    return _repository.updateChallenge(challenge);
  }

  Future<Either<Failure, Unit>> deleteChallenge(final String challengeId) {
    return _repository.deleteChallenge(challengeId);
  }

  Future<Either<Failure, int>> getFriendsInChallengeCount(
      final String challengeId,
      ) {
    return _repository.getFriendsInChallengeCount(challengeId);
  }

  Future<Either<Failure, List<CustomHabitEntity>>> getUserHabits() {
    return _repository.getUserHabits();
  }

  Future<Either<Failure, CustomHabitEntity>> getHabitById(
      final String habitId,
      ) {
    return _repository.getHabitById(habitId);
  }

  Future<Either<Failure, String>> saveHabit(final CustomHabitEntity habit) {
    return _repository.saveHabit(habit);
  }

  Future<Either<Failure, Unit>> deleteHabit(final String habitId) {
    return _repository.deleteHabit(habitId);
  }

  Future<Either<Failure, List<HabitLogEntity>>> getHabitLogsByDateRange({
    required final String habitId,
    required final DateTime startDate,
    required final DateTime endDate,
  }) {
    return _repository.getHabitLogsByDateRange(
      habitId: habitId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // NEW: Save habit log
  Future<Either<Failure, Unit>> saveHabitLog({
    required final String habitId,
    required final HabitLogEntity log,
  }) {
    return _repository.saveHabitLog(habitId: habitId, log: log);
  }

  // NEW: Get friends with same goal count
  Future<Either<Failure, int>> getFriendsWithSameGoalCount({
    required final String habitName,
  }) {
    return _repository.getFriendsWithSameGoalCount(habitName: habitName);
  }

}