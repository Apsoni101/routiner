// lib/feature/challenge/presentation/bloc/challenge_list_bloc/challenge_list_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/enums/log_status.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/domain/usecase/challenge_local_usecase.dart';
import 'package:routiner/feature/challenge/domain/usecase/challenge_remote_usecase.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

part 'challenge_list_event.dart';
part 'challenge_list_state.dart';

class ChallengesListBloc
    extends Bloc<ChallengesListEvent, ChallengesListState> {
  ChallengesListBloc({
    required final ChallengeRemoteUsecase remoteUsecase,
    required final ChallengeLocalUsecase localUsecase,
  })  : _remoteUsecase = remoteUsecase,
        _localUsecase = localUsecase,
        super(const ChallengesListInitial()) {
    on<LoadAllChallenges>(_onLoadAllChallenges);
    on<RefreshChallenges>(_onRefreshChallenges);
  }

  final ChallengeRemoteUsecase _remoteUsecase;
  final ChallengeLocalUsecase _localUsecase;

  Future<void> _onLoadAllChallenges(
      final LoadAllChallenges event,
      final Emitter<ChallengesListState> emit,
      ) async {
    emit(const ChallengesListLoading());

    // 1. Load from local storage first (instant UI)
    final List<ChallengeEntity> localChallenges = await _localUsecase
        .getAllChallenges();

    if (localChallenges.isNotEmpty) {
      // Load cached progress for each challenge
      final List<ChallengeEntity> challengesWithProgress = <ChallengeEntity>[];

      for (final ChallengeEntity challenge in localChallenges) {
        final Map<String, dynamic>? cachedProgress = await _localUsecase
            .getChallengeProgress(challenge.id!);

        if (cachedProgress != null) {
          challengesWithProgress.add(
            challenge.copyWith(
              totalGoalValue: cachedProgress['totalGoalValue'] as int?,
              completedValue: cachedProgress['completedValue'] as int?,
            ),
          );
        } else {
          challengesWithProgress.add(challenge);
        }
      }

      emit(ChallengesListLoaded(challengesWithProgress));
    }

    // 2. Fetch from remote (background sync)
    await _syncWithRemote(emit);
  }

  Future<void> _onRefreshChallenges(
      final RefreshChallenges event,
      final Emitter<ChallengesListState> emit,
      ) async {
    // Only show local data first if it's a pull-to-refresh (not forced remote)
    if (!event.forceRemote) {
      final List<ChallengeEntity> localChallenges = await _localUsecase
          .getAllChallenges();

      if (localChallenges.isNotEmpty) {
        final List<ChallengeEntity> challengesWithProgress = <ChallengeEntity>[];

        for (final ChallengeEntity challenge in localChallenges) {
          final Map<String, dynamic>? cachedProgress = await _localUsecase
              .getChallengeProgress(challenge.id!);

          if (cachedProgress != null) {
            challengesWithProgress.add(
              challenge.copyWith(
                totalGoalValue: cachedProgress['totalGoalValue'] as int?,
                completedValue: cachedProgress['completedValue'] as int?,
              ),
            );
          } else {
            challengesWithProgress.add(challenge);
          }
        }

        emit(ChallengesListLoaded(challengesWithProgress));
      }
    }

    // Always sync with remote to get latest data
    await _syncWithRemote(emit);
  }

  Future<void> _syncWithRemote(
      final Emitter<ChallengesListState> emit,
      ) async {
    final Either<Failure, List<ChallengeEntity>> result = await _remoteUsecase
        .getAllChallenges();

    await result.fold(
          (final Failure failure) async {
        // Keep showing local data on error
        if (state is! ChallengesListLoaded) {
          emit(ChallengesListError(failure.message));
        }
      },
          (final List<ChallengeEntity> remoteChallenges) async {
        final List<ChallengeEntity> challengesWithProgress = <ChallengeEntity>[];

        for (final ChallengeEntity challenge in remoteChallenges) {
          final ChallengeEntity updatedChallenge =
          await _calculateChallengeProgress(challenge);
          challengesWithProgress.add(updatedChallenge);

          // Save to local storage
          await _localUsecase.saveChallenge(updatedChallenge);

          // Cache progress
          await _localUsecase.saveChallengeProgress(
            challengeId: updatedChallenge.id!,
            totalGoalValue: updatedChallenge.totalGoalValue ?? 0,
            completedValue: updatedChallenge.completedValue ?? 0,
          );
        }

        // Update local challenges list
        await _localUsecase.updateChallengesList(challengesWithProgress);

        // Save sync time
        await _localUsecase.saveLastSyncTime(DateTime.now());

        emit(ChallengesListLoaded(challengesWithProgress));
      },
    );
  }

  /// Calculate total goal value and completed value for a challenge
  Future<ChallengeEntity> _calculateChallengeProgress(
      final ChallengeEntity challenge,
      ) async {
    if (challenge.habitIds == null || challenge.habitIds!.isEmpty) {
      return challenge.copyWith(
        totalGoalValue: 0,
        completedValue: 0,
      );
    }

    int totalGoal = 0;
    int completedValue = 0;

    final DateTime startDate = challenge.startDate ??
        challenge.createdAt ??
        DateTime.now();
    final DateTime endDate = challenge.endDate ?? DateTime.now();

    for (final String habitId in challenge.habitIds!) {
      final Either<Failure, CustomHabitEntity> habitResult =
      await _remoteUsecase.getHabitById(habitId);

      await habitResult.fold(
            (final Failure failure) async {
          // Skip this habit if we can't fetch it
        },
            (final CustomHabitEntity habit) async {
          final int habitGoalValue = habit.goalValue ?? 1;
          final int duration = challenge.duration ?? 1;

          totalGoal += habitGoalValue * duration;

          final Either<Failure, List<HabitLogEntity>> logsResult =
          await _remoteUsecase.getHabitLogsByDateRange(
            habitId: habitId,
            startDate: startDate,
            endDate: endDate,
          );

          logsResult.fold(
                (final Failure failure) {
              final DateTime currentDate = DateTime.now();
              final int elapsedDays = currentDate.difference(startDate).inDays;

              if (elapsedDays > 0 && elapsedDays <= duration) {
                completedValue += ((habitGoalValue * elapsedDays) * 0.5).round();
              }
            },
                (final List<HabitLogEntity> logs) {
              for (final HabitLogEntity log in logs) {
                if (log.status == LogStatus.completed) {
                  completedValue += log.completedValue ?? habitGoalValue;
                }
              }
            },
          );
        },
      );
    }

    return challenge.copyWith(
      totalGoalValue: totalGoal,
      completedValue: completedValue,
    );
  }
}