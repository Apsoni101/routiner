import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/data/data_source/remote/challenge_remote_data_source.dart';
import 'package:routiner/feature/challenge/data/model/challenge_model.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/domain/repo/challenge_remote_repository.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_model.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/data/model/habit_log_hive_model.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

class ChallengeRemoteRepositoryImpl implements ChallengeRemoteRepository {
  ChallengeRemoteRepositoryImpl(this._remoteDataSource);

  final ChallengeRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, String>> getCurrentUserId() {
    return _remoteDataSource.getCurrentUserId();
  }

  @override
  Future<Either<Failure, String>> createChallenge(
      final ChallengeEntity challenge,
      ) {
    return _remoteDataSource.createChallenge(
      challenge: ChallengeModel.fromEntity(challenge),
    );
  }

  @override
  Future<Either<Failure, List<ChallengeEntity>>> getAllChallenges() async {
    final Either<Failure, List<ChallengeModel>> result =
    await _remoteDataSource.getAllChallenges();

    return result.fold(
      Left.new,
          (final List<ChallengeModel> models) =>
          Right(models.map((final ChallengeModel m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, ChallengeEntity>> getChallengeById(
      final String challengeId,
      ) async {
    final Either<Failure, ChallengeModel> result =
    await _remoteDataSource.getChallengeById(challengeId: challengeId);

    return result.fold(
      Left.new,
          (final ChallengeModel model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateChallenge(
      final ChallengeEntity challenge,
      ) {
    return _remoteDataSource.updateChallenge(
      challenge: ChallengeModel.fromEntity(challenge),
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteChallenge(final String challengeId) {
    return _remoteDataSource.deleteChallenge(challengeId: challengeId);
  }

  @override
  Future<Either<Failure, int>> getFriendsInChallengeCount(
      final String challengeId,
      ) {
    return _remoteDataSource.getFriendsInChallengeCount(
      challengeId: challengeId,
    );
  }

  @override
  Future<Either<Failure, List<CustomHabitEntity>>> getUserHabits() async {
    final Either<Failure, List<CustomHabitModel>> result =
    await _remoteDataSource.getUserHabits();

    return result.fold(
      Left.new,
          (final List<CustomHabitModel> models) => Right(
        models.map((final CustomHabitModel m) => m.toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, CustomHabitEntity>> getHabitById(
      final String habitId,
      ) async {
    final Either<Failure, CustomHabitModel> result =
    await _remoteDataSource.getHabitById(habitId: habitId);

    return result.fold(
      Left.new,
          (final CustomHabitModel model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, String>> saveHabit(final CustomHabitEntity habit) {
    return _remoteDataSource.saveHabit(habit: habit.toModel());
  }

  @override
  Future<Either<Failure, Unit>> deleteHabit(final String habitId) {
    return _remoteDataSource.deleteHabit(habitId: habitId);
  }

  @override
  Future<Either<Failure, List<HabitLogEntity>>> getHabitLogsByDateRange({
    required final String habitId,
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    return _remoteDataSource.getHabitLogsByDateRange(
      habitId: habitId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // NEW: Save habit log
  @override
  Future<Either<Failure, Unit>> saveHabitLog({
    required final String habitId,
    required final HabitLogEntity log,
  }) {
    return _remoteDataSource.saveHabitLog(
      habitId: habitId,
      log: HabitLogHiveModel.fromEntity(log),
    );
  }

  // NEW: Get friends with same goal count
  @override
  Future<Either<Failure, int>> getFriendsWithSameGoalCount({
    required final String habitName,
  }) {
    return _remoteDataSource.getFriendsWithSameGoalCount(habitName: habitName);
  }
  @override
  Future<Either<Failure, String>> saveChallengeHabit({
    required final CustomHabitEntity habit,
  }) async {
    final CustomHabitModel model = CustomHabitModel.fromEntity(habit);
    return _remoteDataSource.saveChallengeHabit(habit: model);
  }
}