// lib/feature/challenge/presentation/bloc/challenge_detail_bloc/challenge_detail_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:routiner/core/enums/log_status.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/domain/usecase/challenge_local_usecase.dart';
import 'package:routiner/feature/challenge/domain/usecase/challenge_remote_usecase.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_with_log.dart';

part 'challenge_detail_event.dart';

part 'challenge_detail_state.dart';

class ChallengeDetailBloc
    extends Bloc<ChallengeDetailEvent, ChallengeDetailState> {
  ChallengeDetailBloc({
    required final ChallengeRemoteUsecase remoteUsecase,
    required final ChallengeLocalUsecase localUsecase,
  }) : _remoteUsecase = remoteUsecase,
       _localUsecase = localUsecase,
       super(ChallengeDetailInitial()) {
    on<LoadChallengeDetail>(_onLoadChallengeDetail);
    on<JoinChallenge>(_onJoinChallenge);
    on<RefreshChallengeHabits>(_onRefreshChallengeHabits);
    on<UpdateChallengeHabitLog>(_onUpdateChallengeHabitLog);
  }

  final ChallengeRemoteUsecase _remoteUsecase;
  final ChallengeLocalUsecase _localUsecase;

  Future<void> _onLoadChallengeDetail(
    final LoadChallengeDetail event,
    final Emitter<ChallengeDetailState> emit,
  ) async {
    emit(ChallengeDetailLoading());

    // 1. Try to load from local storage first
    final ChallengeEntity? localChallenge = await _localUsecase
        .getChallengeById(event.challengeId);

    if (localChallenge != null) {
      await _emitChallengeData(localChallenge, emit);
    }

    // 2. Fetch from remote and update local (background sync)
    await _syncChallengeFromRemote(event.challengeId, emit);
  }

  Future<void> _syncChallengeFromRemote(
    final String challengeId,
    final Emitter<ChallengeDetailState> emit,
  ) async {
    // Get current user ID
    final Either<Failure, String> userIdResult = await _remoteUsecase
        .getCurrentUserId();

    String? currentUserId;
    userIdResult.fold((final Failure failure) {}, (final String userId) {
      currentUserId = userId;
    });

    final Either<Failure, ChallengeEntity> challengeResult =
        await _remoteUsecase.getChallengeById(challengeId);

    await challengeResult.fold(
      (final Failure failure) async {
        // Only emit error if we don't have local data
        if (state is! ChallengeDetailLoaded) {
          emit(ChallengeDetailError(failure.message));
        }
      },
      (final ChallengeEntity challenge) async {
        // Save to local storage
        await _localUsecase.saveChallenge(challenge);

        // Save participant IDs cache
        if (challenge.participantIds != null) {
          await _localUsecase.saveParticipantIds(
            challengeId: challenge.id!,
            participantIds: challenge.participantIds!,
          );
        }

        // Emit updated data
        await _emitChallengeData(challenge, emit, currentUserId: currentUserId);
      },
    );
  }

  Future<void> _emitChallengeData(
    final ChallengeEntity challenge,
    final Emitter<ChallengeDetailState> emit, {
    final String? currentUserId,
  }) async {
    final List<CustomHabitEntity> habits = <CustomHabitEntity>[];
    final List<HabitWithLog> habitsWithLogs = <HabitWithLog>[];
    final Map<String, int> habitFriendsCountMap = <String, int>{};

    // Load habits from local storage first
    final List<CustomHabitEntity> allLocalHabits = await _localUsecase
        .getAllHabits();

    for (final String habitId in challenge.habitIds ?? <String>[]) {
      // Try local first
      CustomHabitEntity? habit = allLocalHabits
          .cast<CustomHabitEntity?>()
          .firstWhere(
            (final CustomHabitEntity? h) => h?.id == habitId,
            orElse: () => null,
          );

      // If not in local, fetch from remote (will check both user habits and global challenge_habits)
      if (habit == null) {
        final Either<Failure, CustomHabitEntity> habitResult =
            await _remoteUsecase.getHabitById(habitId);

        await habitResult.fold((final Failure failure) async {}, (
          final CustomHabitEntity remoteHabit,
        ) async {
          habit = remoteHabit;
          // Save to local storage so it's available next time
          await _localUsecase.saveHabit(remoteHabit);
        });
      }

      // Skip this habit if it couldn't be loaded
      if (habit == null) {
        continue;
      }

      habits.add(habit!);

      // Load habit logs for today from local storage
      final DateTime today = DateTime.now();
      final List<HabitLogEntity> allLocalLogs = await _localUsecase
          .getAllHabitLogs();

      final HabitLogEntity logForToday =
          allLocalLogs.cast<HabitLogEntity?>().firstWhere(
            (final HabitLogEntity? log) =>
                log?.habitId == habitId &&
                log?.date.year == today.year &&
                log?.date.month == today.month &&
                log?.date.day == today.day,
            orElse: () => null,
          ) ??
          HabitLogEntity(
            id: '',
            habitId: habitId,
            date: today,
            goalValue: habit!.goalValue,
          );

      habitsWithLogs.add(HabitWithLog(habit: habit!, log: logForToday));

      // Get friends count from local cache
      if (habit!.name != null) {
        final int? cachedCount = await _localUsecase.getFriendsCount(habitId);

        if (cachedCount != null) {
          habitFriendsCountMap[habitId] = cachedCount;
        } else {
          // Fetch from remote in background
          await _fetchAndCacheFriendsCount(habitId, habit!.name!);
          habitFriendsCountMap[habitId] = 0;
        }
      }
    }

    // Get cached participant count or fetch from remote
    final List<String>? cachedParticipants = await _localUsecase
        .getParticipantIds(challenge.id!);

    int friendsCount = 0;
    if (cachedParticipants != null) {
      // Calculate friends count from cached participants
      final Either<Failure, String> userIdResult = await _remoteUsecase
          .getCurrentUserId();

      await userIdResult.fold((final Failure failure) async {}, (
        final String userId,
      ) async {
        friendsCount = cachedParticipants
            .where((final String id) => id != userId)
            .length;
      });
    } else {
      // Fetch from remote
      final Either<Failure, int> friendsCountResult = await _remoteUsecase
          .getFriendsInChallengeCount(challenge.id!);

      friendsCountResult.fold(
        (final Failure failure) {
          friendsCount = 0;
        },
        (final int count) {
          friendsCount = count;
        },
      );
    }

    emit(
      ChallengeDetailLoaded(
        challenge: challenge,
        habits: habits,
        friendsCount: friendsCount,
        currentUserId: currentUserId,
        habitsWithLogs: habitsWithLogs,
        habitFriendsCountMap: habitFriendsCountMap,
      ),
    );
  }

  Future<void> _fetchAndCacheFriendsCount(
    final String habitId,
    final String habitName,
  ) async {
    final Either<Failure, int> result = await _remoteUsecase
        .getFriendsWithSameGoalCount(habitName: habitName);

    result.fold(
      (final Failure failure) {
        // Cache 0 on failure
        _localUsecase.saveFriendsCount(habitId, 0);
      },
      (final int count) {
        _localUsecase.saveFriendsCount(habitId, count);
      },
    );
  }

  Future<void> _onJoinChallenge(
    final JoinChallenge event,
    final Emitter<ChallengeDetailState> emit,
  ) async {
    final ChallengeDetailState currentState = state;
    if (currentState is! ChallengeDetailLoaded) {
      return;
    }

    // Get current user ID
    final Either<Failure, String> userIdResult = await _remoteUsecase
        .getCurrentUserId();

    final String? userId = userIdResult.fold((final Failure failure) {
      emit(
        currentState.copyWith(
          errorMessage: 'Failed to get user ID: ${failure.message}',
        ),
      );
      return null;
    }, (final String id) => id);

    if (userId == null) {
      return;
    }

    emit(ChallengeDetailLoading());

    final ChallengeEntity challenge = currentState.challenge;

    if ((challenge.participantIds ?? <String>[]).contains(userId)) {
      emit(
        currentState.copyWith(
          errorMessage: 'You have already joined this challenge',
        ),
      );
      return;
    }

    final List<String> updatedParticipants = List<String>.from(
      challenge.participantIds ?? <dynamic>[],
    )..add(userId);

    final ChallengeEntity updatedChallenge = challenge.copyWith(
      participantIds: updatedParticipants,
    );

    final Either<Failure, Unit> updateResult = await _remoteUsecase
        .updateChallenge(updatedChallenge);

    await updateResult.fold(
      (final Failure failure) async {
        emit(currentState.copyWith(errorMessage: failure.message));
      },
      (_) async {
        // Update local storage
        await _localUsecase.saveChallenge(updatedChallenge);
        await _localUsecase.saveParticipantIds(
          challengeId: updatedChallenge.id!,
          participantIds: updatedParticipants,
        );

        // Get user habits from local storage
        final List<CustomHabitEntity> userHabits = await _localUsecase
            .getAllHabits();

        for (final String habitId in challenge.habitIds ?? <String>[]) {
          final Either<Failure, CustomHabitEntity> habitResult =
              await _remoteUsecase.getHabitById(habitId);

          await habitResult.fold((final Failure failure) async {}, (
            final CustomHabitEntity challengeHabit,
          ) async {
            final CustomHabitEntity? existingHabit = userHabits
                .cast<CustomHabitEntity?>()
                .firstWhere(
                  (final CustomHabitEntity? h) =>
                      h?.name?.toLowerCase().trim() ==
                      challengeHabit.name?.toLowerCase().trim(),
                  orElse: () => null,
                );

            if (existingHabit == null) {
              await _remoteUsecase.saveHabit(challengeHabit);
            }
          });
        }

        add(LoadChallengeDetail(challenge.id!));
      },
    );
  }

  Future<void> _onUpdateChallengeHabitLog(
    final UpdateChallengeHabitLog event,
    final Emitter<ChallengeDetailState> emit,
  ) async {
    final ChallengeDetailState currentState = state;
    if (currentState is! ChallengeDetailLoaded) {
      return;
    }

    // Generate log ID if not present
    final String logId = event.log.id?.isEmpty ?? true
        ? '${event.log.habitId}_${event.log.date.toIso8601String().split('T')[0]}'
        : event.log.id!;

    // Update the log with new values
    final HabitLogEntity updatedLog = event.log.copyWith(
      id: logId,
      status: event.status,
      completedValue: event.completedValue,
      completedAt: event.status == LogStatus.completed ? DateTime.now() : null,
    );

    // Save to local storage first (instant update)
    await _localUsecase.saveHabitLog(updatedLog);

    // Update logs list in local storage
    final List<HabitLogEntity> allLogs = await _localUsecase.getAllHabitLogs();
    final int index = allLogs.indexWhere(
      (final HabitLogEntity log) => log.id == logId,
    );
    if (index != -1) {
      allLogs[index] = updatedLog;
    } else {
      allLogs.add(updatedLog);
    }
    await _localUsecase.updateHabitLogsList(allLogs);

    // Reload challenge with updated local data
    add(LoadChallengeDetail(currentState.challenge.id!));

    // Save to remote in background
    final Either<Failure, Unit> saveResult = await _remoteUsecase.saveHabitLog(
      habitId: updatedLog.habitId,
      log: updatedLog,
    );

    saveResult.fold((final Failure failure) {}, (_) {});
  }

  Future<void> _onRefreshChallengeHabits(
    final RefreshChallengeHabits event,
    final Emitter<ChallengeDetailState> emit,
  ) async {
    add(LoadChallengeDetail(event.challengeId));
  }
}
