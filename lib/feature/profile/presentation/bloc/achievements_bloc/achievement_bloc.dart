import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/enums/achievement_type.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/domain/entity/achievement_entity.dart';
import 'package:routiner/feature/profile/domain/usecase/profile_local_usecase.dart';
import 'package:routiner/feature/profile/domain/usecase/profile_remote_usecase.dart';

part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  AchievementsBloc({required this.remoteUseCase, required this.localUseCase})
      : super(const AchievementsInitial()) {
    on<LoadAchievements>(_onLoadAchievements);
    on<RefreshAchievements>(_onRefreshAchievements);
    on<UpdateAchievementProgress>(_onUpdateProgress);
    on<CheckAndUnlockAchievements>(_onCheckAndUnlock);
    on<ClearAchievementNotifications>(_onClearNotifications);
  }

  final ProfileRemoteUseCase remoteUseCase;
  final ProfileLocalUseCase localUseCase;

  /// Load achievements with optimized caching strategy
  Future<void> _onLoadAchievements(
      final LoadAchievements event,
      final Emitter<AchievementsState> emit,
      ) async {
    emit(const AchievementsLoading());

    // Initialize achievements
    await remoteUseCase.initializeAchievements();

    // Get local cache immediately
    final List<AchievementEntity> localAchievements = await localUseCase
        .getAchievements();

    // If we have local data, show it immediately
    if (localAchievements.isNotEmpty && !isClosed) {
      final List<AchievementEntity> updatedLocal =
      await _calculateAchievementProgress(localAchievements);
      if (!isClosed) {
        emit(AchievementsLoaded(achievements: updatedLocal));
      }
    }

    // Fetch remote and local data in parallel for calculations
    final Future<List<ActivityEntity>> activitiesFuture = localUseCase
        .getActivities();
    final Future<int> totalPointsFuture = localUseCase.getTotalPoints();
    final Future<Either<Failure, List<AchievementEntity>>>
    remoteAchievementsFuture = remoteUseCase.getAchievements();

    // Wait for all to complete
    final List<Object> results = await Future.wait(<Future<Object>>[
      activitiesFuture,
      totalPointsFuture,
      remoteAchievementsFuture,
    ]);

    if (isClosed) return;

    final List<ActivityEntity> activities = results[0] as List<ActivityEntity>;
    final int totalPoints = results[1] as int;
    final Either<Failure, List<AchievementEntity>> remoteResult =
    results[2] as Either<Failure, List<AchievementEntity>>;

    await remoteResult.fold(
          (final Failure failure) async {
        if (localAchievements.isEmpty && !isClosed) {
          emit(AchievementsError(failure.message));
        }
      },
          (final List<AchievementEntity> remoteAchievements) async {
        if (isClosed) return;

        final List<AchievementEntity> updatedAchievements =
        _calculateProgressWithData(
          remoteAchievements,
          totalPoints,
          activities,
        );
        await localUseCase.saveAchievements(updatedAchievements);

        if (!isClosed) {
          emit(AchievementsLoaded(achievements: updatedAchievements));
          add(const CheckAndUnlockAchievements());
        }
      },
    );
  }

  /// Refresh achievements with parallel remote + local fetch
  Future<void> _onRefreshAchievements(
      final RefreshAchievements event,
      final Emitter<AchievementsState> emit,
      ) async {
    final AchievementsState currentState = state;

    // Fetch remote achievements and supporting data in parallel
    final Future<Either<Failure, List<AchievementEntity>>>
    remoteAchievementsFuture = remoteUseCase.getAchievements();
    final Future<List<ActivityEntity>> activitiesFuture = localUseCase
        .getActivities();
    final Future<int> totalPointsFuture = localUseCase.getTotalPoints();

    final List<Object> results = await Future.wait(<Future<Object>>[
      remoteAchievementsFuture,
      activitiesFuture,
      totalPointsFuture,
    ]);

    if (isClosed) return;

    final Either<Failure, List<AchievementEntity>> remoteResult =
    results[0] as Either<Failure, List<AchievementEntity>>;
    final List<ActivityEntity> activities = results[1] as List<ActivityEntity>;
    final int totalPoints = results[2] as int;

    await remoteResult.fold(
          (final Failure failure) async {
        if (currentState is! AchievementsLoaded && !isClosed) {
          emit(AchievementsError(failure.message));
        }
      },
          (final List<AchievementEntity> achievements) async {
        if (isClosed) return;

        final List<AchievementEntity> updated = _calculateProgressWithData(
          achievements,
          totalPoints,
          activities,
        );
        await localUseCase.saveAchievements(updated);

        if (!isClosed) {
          emit(AchievementsLoaded(achievements: updated));
          add(const CheckAndUnlockAchievements());
        }
      },
    );
  }

  Future<void> _onUpdateProgress(
      final UpdateAchievementProgress event,
      final Emitter<AchievementsState> emit,
      ) async {
    if (state is! AchievementsLoaded || isClosed) {
      return;
    }

    final AchievementsLoaded currentState = state as AchievementsLoaded;

    final List<AchievementEntity> updatedAchievements = currentState
        .achievements
        .map((final AchievementEntity achievement) {
      if (achievement.type == event.type && !achievement.isUnlocked) {
        final int newProgress =
            achievement.currentProgress + event.increment;
        return achievement.copyWith(currentProgress: newProgress);
      }
      return achievement;
    })
        .toList();

    await localUseCase.saveAchievements(updatedAchievements);

    if (!isClosed) {
      emit(
        AchievementsLoaded(
          achievements: updatedAchievements,
          newlyUnlocked: currentState.newlyUnlocked,
        ),
      );

      add(const CheckAndUnlockAchievements());
    }
  }

  Future<void> _onCheckAndUnlock(
      final CheckAndUnlockAchievements event,
      final Emitter<AchievementsState> emit,
      ) async {
    if (state is! AchievementsLoaded || isClosed) {
      return;
    }

    final AchievementsLoaded currentState = state as AchievementsLoaded;
    final List<AchievementEntity> newlyUnlocked = <AchievementEntity>[];
    final List<AchievementEntity> updatedList = <AchievementEntity>[];

    for (final AchievementEntity achievement in currentState.achievements) {
      if (!achievement.isUnlocked && achievement.isCompleted) {
        final AchievementEntity unlocked = achievement.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );

        // Update remote and local in parallel
        await Future.wait(<Future<Object>>[
          remoteUseCase.updateAchievement(unlocked),
          localUseCase.updateAchievement(unlocked),
        ]);

        newlyUnlocked.add(unlocked);
        updatedList.add(unlocked);
      } else {
        updatedList.add(achievement);
      }
    }

    if (newlyUnlocked.isNotEmpty && !isClosed) {
      await localUseCase.saveAchievements(updatedList);

      emit(
        AchievementsLoaded(
          achievements: updatedList,
          newlyUnlocked: newlyUnlocked,
        ),
      );
    }
  }

  Future<void> _onClearNotifications(
      final ClearAchievementNotifications event,
      final Emitter<AchievementsState> emit,
      ) async {
    if (state is! AchievementsLoaded || isClosed) {
      return;
    }

    final AchievementsLoaded currentState = state as AchievementsLoaded;

    emit(AchievementsLoaded(achievements: currentState.achievements));
  }

  /// Calculate progress with pre-fetched data (faster than fetching again)
  List<AchievementEntity> _calculateProgressWithData(
      final List<AchievementEntity> achievements,
      final int totalPoints,
      final List<ActivityEntity> activities,
      ) {
    return achievements.map((final AchievementEntity achievement) {
      int progress = achievement.currentProgress;

      switch (achievement.type) {
        case AchievementType.pointsMilestone:
          progress = totalPoints;
          break;

        case AchievementType.habitStreak:
          progress = _calculateCurrentStreak(activities);
          break;

        case AchievementType.consistency:
          progress = _calculateConsecutiveDays(activities);
          break;

        case AchievementType.earlyBird:
          progress = _countEarlyBirdActivities(activities);
          break;

        case AchievementType.totalHabits:
        case AchievementType.challengeWin:
        case AchievementType.socialButterfly:
          break;

        case AchievementType.perfectWeek:
          progress = _calculatePerfectWeeks(activities);
          break;
      }

      return achievement.copyWith(currentProgress: progress);
    }).toList();
  }

  /// Legacy method for backward compatibility - now calls optimized version
  Future<List<AchievementEntity>> _calculateAchievementProgress(
      final List<AchievementEntity> achievements,
      ) async {
    final int totalPoints = await localUseCase.getTotalPoints();
    final List<ActivityEntity> activities = await localUseCase.getActivities();

    return _calculateProgressWithData(achievements, totalPoints, activities);
  }

  /// Get sorted unlocked achievements - most recently unlocked first
  List<AchievementEntity> getSortedUnlockedAchievements(
      final List<AchievementEntity> achievements,
      ) {
    return achievements
        .where((final AchievementEntity a) => a.isUnlocked)
        .toList()
      ..sort(
            (final AchievementEntity a, final AchievementEntity b) =>
            (b.unlockedAt ?? DateTime.now()).compareTo(
              a.unlockedAt ?? DateTime.now(),
            ),
      );
  }

  int _calculateCurrentStreak(final List<ActivityEntity> activities) {
    if (activities.isEmpty) {
      return 0;
    }

    final List<DateTime> activityDates =
    activities
        .map((final ActivityEntity a) => _normalizeDate(a.timestamp))
        .toSet()
        .toList()
      ..sort((final DateTime a, final DateTime b) => b.compareTo(a));

    if (activityDates.isEmpty) {
      return 0;
    }

    final DateTime today = _normalizeDate(DateTime.now());
    final DateTime yesterday = today.subtract(const Duration(days: 1));

    if (activityDates.first != today && activityDates.first != yesterday) {
      return 0;
    }

    int streak = 1;
    for (int i = 0; i < activityDates.length - 1; i++) {
      final int diff = activityDates[i].difference(activityDates[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  int _calculateConsecutiveDays(final List<ActivityEntity> activities) {
    if (activities.isEmpty) {
      return 0;
    }

    final List<DateTime> uniqueDates =
    activities
        .map((final ActivityEntity a) => _normalizeDate(a.timestamp))
        .toSet()
        .toList()
      ..sort((final DateTime a, final DateTime b) => b.compareTo(a));

    if (uniqueDates.isEmpty) {
      return 0;
    }

    final DateTime today = _normalizeDate(DateTime.now());
    if (uniqueDates.first != today) {
      return 0;
    }

    int consecutive = 1;
    for (int i = 0; i < uniqueDates.length - 1; i++) {
      final int diff = uniqueDates[i].difference(uniqueDates[i + 1]).inDays;
      if (diff == 1) {
        consecutive++;
      } else {
        break;
      }
    }

    return consecutive;
  }

  int _countEarlyBirdActivities(final List<ActivityEntity> activities) {
    return activities
        .where((final ActivityEntity activity) => activity.timestamp.hour < 9)
        .length;
  }

  int _calculatePerfectWeeks(final List<ActivityEntity> activities) {
    if (activities.isEmpty) {
      return 0;
    }

    final Map<int, Set<DateTime>> weekActivities = <int, Set<DateTime>>{};

    for (final ActivityEntity activity in activities) {
      final DateTime date = _normalizeDate(activity.timestamp);
      final int weekNumber = _getWeekNumber(date);

      weekActivities.putIfAbsent(weekNumber, () => <DateTime>{});
      weekActivities[weekNumber]!.add(date);
    }

    int perfectWeeks = 0;
    for (final Set<DateTime> dates in weekActivities.values) {
      if (dates.length >= 7) {
        final List<DateTime> sortedDates = dates.toList()..sort();
        if (_hasConsecutiveDays(sortedDates, 7)) {
          perfectWeeks++;
        }
      }
    }

    return perfectWeeks;
  }

  DateTime _normalizeDate(final DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  int _getWeekNumber(final DateTime date) {
    final DateTime firstDayOfYear = DateTime(date.year);
    final int daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor();
  }

  bool _hasConsecutiveDays(final List<DateTime> dates, final int n) {
    if (dates.length < n) {
      return false;
    }

    int consecutive = 1;
    for (int i = 0; i < dates.length - 1; i++) {
      final int diff = dates[i + 1].difference(dates[i]).inDays;
      if (diff == 1) {
        consecutive++;
        if (consecutive >= n) {
          return true;
        }
      } else {
        consecutive = 1;
      }
    }

    return consecutive >= n;
  }
}