import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/enums/activity_type.dart';
import 'package:routiner/core/enums/log_status.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_with_log.dart';
import 'package:routiner/feature/home/domain/usecase/habit_display_local_usecase.dart';
import 'package:routiner/feature/home/domain/usecase/habits_display_remote_usecase.dart';
import 'package:routiner/core/constants/points_constants.dart';
import 'package:uuid/uuid.dart';

part 'habit_display_event.dart';

part 'habit_display_state.dart';

class HabitDisplayBloc extends Bloc<HabitDisplayEvent, HabitDisplayState> {
  HabitDisplayBloc({
    required final HabitDisplayLocalUsecase habitDisplayUsecase,
    required final HabitsDisplayRemoteUsecase remoteUsecase,
  }) : _habitUsecase = habitDisplayUsecase,
       _remoteUsecase = remoteUsecase,
       super(HabitDisplayInitial()) {
    on<LoadHabitsForDate>(_loadHabits);
    on<UpdateHabitLogStatus>(_updateHabitLog);
    on<RefreshHabits>(_refreshHabits);
    on<LoadChallenges>(_loadChallenges);
  }

  final HabitDisplayLocalUsecase _habitUsecase;
  final HabitsDisplayRemoteUsecase _remoteUsecase;
  final Uuid _uuid = const Uuid();
  DateTime _currentDate = DateTime.now();

  Future<void> _loadHabits(
    final LoadHabitsForDate event,
    final Emitter<HabitDisplayState> emit,
  ) async {
    _currentDate = event.date;
    emit(HabitDisplayLoading());

    final List<HabitWithLog> localHabits = await _fetchHabitsWithLogs(
      _currentDate,
    );
    final Map<String, int> cachedFriendsCounts = await _habitUsecase
        .getAllFriendsCounts();
    final int totalPoints = await _habitUsecase.getTotalPoints();

    emit(
      HabitDisplayLoaded(
        habitsWithLogs: localHabits,
        selectedDate: _currentDate,
        friendsCountMap: Map<String, int>.from(cachedFriendsCounts),
        totalPoints: totalPoints,
      ),
    );

    add(const LoadChallenges());
    await _syncInBackground(localHabits, cachedFriendsCounts, emit);
  }

  Future<void> _loadChallenges(
    final LoadChallenges event,
    final Emitter<HabitDisplayState> emit,
  ) async {
    final currentState = state;

    if (currentState is! HabitDisplayLoaded) {
      print('⚠️ LoadChallenges: State is not HabitDisplayLoaded, skipping');
      return;
    }

    print('🔄 LoadChallenges: Setting loading flag');
    emit(currentState.copyWith(challengesLoading: true));

    print('📡 LoadChallenges: Fetching challenges from remote');
    final Either<Failure, List<ChallengeEntity>> result = await _remoteUsecase
        .getAllChallenges();

    await result.fold(
      (final Failure failure) async {
        print('❌ LoadChallenges: Failed to fetch - ${failure.message}');
        if (state is HabitDisplayLoaded) {
          emit(
            (state as HabitDisplayLoaded).copyWith(challengesLoading: false),
          );
        }
      },
      (final List<ChallengeEntity> challenges) async {
        print('✅ LoadChallenges: Fetched ${challenges.length} challenges');
        final List<ChallengeEntity> challengesWithProgress =
            <ChallengeEntity>[];

        for (final ChallengeEntity challenge in challenges) {
          final ChallengeEntity updatedChallenge =
              await _calculateChallengeProgress(challenge);
          challengesWithProgress.add(updatedChallenge);
        }

        print('📊 LoadChallenges: Calculated progress for all challenges');
        if (state is HabitDisplayLoaded) {
          print(
            '✨ LoadChallenges: Emitting state with ${challengesWithProgress.length} challenges',
          );
          emit(
            (state as HabitDisplayLoaded).copyWith(
              challenges: challengesWithProgress,
              challengesLoading: false,
            ),
          );
        }
      },
    );
  }

  Future<ChallengeEntity> _calculateChallengeProgress(
    final ChallengeEntity challenge,
  ) async {
    if (challenge.habitIds == null || challenge.habitIds!.isEmpty) {
      return challenge.copyWith(totalGoalValue: 0, completedValue: 0);
    }

    int totalGoal = 0;
    int completedValue = 0;

    final DateTime startDate =
        challenge.startDate ?? challenge.createdAt ?? DateTime.now();
    final DateTime endDate = challenge.endDate ?? DateTime.now();

    for (final String habitId in challenge.habitIds!) {
      final List<CustomHabitEntity> habits = await _habitUsecase
          .getCustomHabits();

      final CustomHabitEntity? habit = habits
          .cast<CustomHabitEntity?>()
          .firstWhere((final h) => h?.id == habitId, orElse: () => null);

      if (habit == null) continue;

      final int habitGoalValue = habit.goalValue ?? 1;
      final int duration = challenge.duration ?? 1;

      totalGoal += habitGoalValue * duration;

      final List<HabitLogEntity> allLogs = await _habitUsecase.getAllLogs();

      final List<HabitLogEntity> logsInRange = allLogs.where((log) {
        return log.habitId == habitId &&
            log.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            log.date.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      for (final HabitLogEntity log in logsInRange) {
        if (log.status == LogStatus.completed) {
          completedValue += log.completedValue ?? habitGoalValue;
        }
      }
    }

    return challenge.copyWith(
      totalGoalValue: totalGoal,
      completedValue: completedValue,
    );
  }

  Future<void> _syncInBackground(
    final List<HabitWithLog> habits,
    final Map<String, int> cachedCounts,
    final Emitter<HabitDisplayState> emit,
  ) async {
    await Future.wait(<Future<void>>[
      _fetchAndCompareFriendsCount(habits, cachedCounts, emit),
      _syncWithRemote(),
    ]);

    final List<HabitWithLog> syncedHabits = await _fetchHabitsWithLogs(
      _currentDate,
    );
    final Map<String, int> finalFriendsCounts = await _habitUsecase
        .getAllFriendsCounts();
    final int totalPoints = await _habitUsecase.getTotalPoints();

    if (!emit.isDone) {
      final currentState = state;
      if (currentState is HabitDisplayLoaded) {
        emit(
          currentState.copyWith(
            habitsWithLogs: syncedHabits,
            friendsCountMap: Map<String, int>.from(finalFriendsCounts),
            totalPoints: totalPoints,
          ),
        );
      }
    }
  }

  Future<void> _fetchAndCompareFriendsCount(
    final List<HabitWithLog> habits,
    final Map<String, int> cachedCounts,
    final Emitter<HabitDisplayState> emit,
  ) async {
    final List<Future<void>> fetchTasks = habits.map((
      final HabitWithLog habitWithLog,
    ) {
      return _fetchSingleHabitFriendsCount(habitWithLog, cachedCounts);
    }).toList();

    await Future.wait(fetchTasks);

    final Map<String, int> updatedCounts = await _habitUsecase
        .getAllFriendsCounts();

    bool hasChanges = false;
    for (final HabitWithLog habitWithLog in habits) {
      final String? habitId = habitWithLog.habit.id;
      if (habitId != null) {
        final int oldCount = cachedCounts[habitId] ?? 0;
        final int newCount = updatedCounts[habitId] ?? 0;
        if (oldCount != newCount) {
          hasChanges = true;
          break;
        }
      }
    }

    if (hasChanges && !emit.isDone) {
      final currentState = state;
      if (currentState is HabitDisplayLoaded) {
        final List<HabitWithLog> currentHabits = await _fetchHabitsWithLogs(
          _currentDate,
        );
        final int totalPoints = await _habitUsecase.getTotalPoints();

        emit(
          currentState.copyWith(
            habitsWithLogs: currentHabits,
            friendsCountMap: Map<String, int>.from(updatedCounts),
            totalPoints: totalPoints,
          ),
        );
      }
    }
  }

  Future<void> _fetchSingleHabitFriendsCount(
    final HabitWithLog habitWithLog,
    final Map<String, int> cachedCounts,
  ) async {
    final String? habitName = habitWithLog.habit.name;
    final String? habitId = habitWithLog.habit.id;

    if (habitName == null || habitName.isEmpty || habitId == null) return;

    final Either<Failure, int> result = await _remoteUsecase
        .getFriendsWithSameGoalCount(habitName: habitName);

    await result.fold(
      (final Failure failure) async {
        if (!cachedCounts.containsKey(habitId)) {
          await _habitUsecase.saveFriendsCount(habitId, 0);
        }
      },
      (final int remoteCount) async {
        await _habitUsecase.saveFriendsCount(habitId, remoteCount);
      },
    );
  }

  Future<void> _updateHabitLog(
    final UpdateHabitLogStatus event,
    final Emitter<HabitDisplayState> emit,
  ) async {
    if (event.log.status != LogStatus.pending) {
      final currentState = state;
      if (currentState is HabitDisplayLoaded) {
        emit(
          currentState.copyWith(
            errorMessage:
                'habitStatusAlreadySet_${DateTime.now().millisecondsSinceEpoch}',
          ),
        );
      }
      return;
    }

    final String logId = (event.log.id == null || event.log.id!.isEmpty)
        ? _uuid.v4()
        : event.log.id!;

    final HabitLogEntity updatedLog = event.log.copyWith(
      id: logId,
      status: event.status,
      completedValue: event.completedValue,
      completedAt: event.status == LogStatus.completed ? DateTime.now() : null,
    );

    final List<HabitLogEntity> allLogs = await _habitUsecase.getAllLogs();
    final List<HabitLogEntity> updatedLogs = _updateOrAddLog(
      allLogs,
      updatedLog,
      logId,
    );

    await _habitUsecase.updateLogsList(updatedLogs);
    await _habitUsecase.saveLogById(logId, updatedLog);

    int? pointsEarned;

    if (event.status == LogStatus.completed) {
      final List<CustomHabitEntity> habits = await _habitUsecase
          .getCustomHabits();
      final CustomHabitEntity? habit = habits
          .cast<CustomHabitEntity?>()
          .firstWhere((h) => h?.id == event.log.habitId, orElse: () => null);

      final ActivityEntity activity = ActivityEntity(
        id: _uuid.v4(),
        userId: '',
        activityType: ActivityType.habitCompleted,
        points: PointsConstants.habitCompleted,
        description: 'Completed habit: ${habit?.name ?? "Unknown"}',
        timestamp: DateTime.now(),
        relatedHabitId: event.log.habitId,
        relatedHabitName: habit?.name,
      );

      await _habitUsecase.saveActivity(activity);

      _remoteUsecase.saveActivity(activity);

      pointsEarned = PointsConstants.habitCompleted;
    }

    final List<HabitWithLog> habitsWithLogs = await _fetchHabitsWithLogs(
      _currentDate,
    );
    final Map<String, int> friendsCounts = await _habitUsecase
        .getAllFriendsCounts();
    final int totalPoints = await _habitUsecase.getTotalPoints();

    final currentState = state;
    final List<ChallengeEntity> challenges = currentState is HabitDisplayLoaded
        ? currentState.challenges
        : <ChallengeEntity>[];
    final bool challengesLoading = currentState is HabitDisplayLoaded
        ? currentState.challengesLoading
        : false;

    emit(
      HabitDisplayLoaded(
        habitsWithLogs: habitsWithLogs,
        selectedDate: _currentDate,
        friendsCountMap: Map<String, int>.from(friendsCounts),
        challenges: challenges,
        challengesLoading: challengesLoading,
        pointsEarned: pointsEarned,
        totalPoints: totalPoints,
      ),
    );

    await _remoteUsecase.saveLog(habitId: updatedLog.habitId, log: updatedLog);

    add(const LoadChallenges());
  }

  Future<void> _refreshHabits(
    final RefreshHabits event,
    final Emitter<HabitDisplayState> emit,
  ) async {
    final List<HabitWithLog> localHabits = await _fetchHabitsWithLogs(
      _currentDate,
    );
    final Map<String, int> friendsCounts = await _habitUsecase
        .getAllFriendsCounts();
    final int totalPoints = await _habitUsecase.getTotalPoints();

    final currentState = state;
    final List<ChallengeEntity> existingChallenges =
        currentState is HabitDisplayLoaded
        ? currentState.challenges
        : <ChallengeEntity>[];

    emit(
      HabitDisplayLoaded(
        habitsWithLogs: localHabits,
        selectedDate: _currentDate,
        friendsCountMap: Map<String, int>.from(friendsCounts),
        challenges: existingChallenges,
        totalPoints: totalPoints,
      ),
    );

    add(LoadHabitsForDate(_currentDate));
  }

  Future<void> _syncWithRemote() async {
    final List<CustomHabitEntity> habits = await _habitUsecase
        .getCustomHabits();
    final Map<String, List<HabitLogEntity>> remoteLogsByHabit = {};
    final List<HabitLogEntity> allRemoteLogs = [];

    final List<Future<void>> fetchTasks = habits
        .where((habit) => habit.id != null && habit.id!.isNotEmpty)
        .map((habit) async {
          final Either<Failure, List<HabitLogEntity>> remoteResult =
              await _remoteUsecase.getLogsForHabit(habitId: habit.id!);

          await remoteResult.fold((failure) async {}, (logs) async {
            remoteLogsByHabit[habit.id!] = logs;
            allRemoteLogs.addAll(logs);
          });
        })
        .toList();

    await Future.wait(fetchTasks);

    final List<HabitLogEntity> localLogs = await _habitUsecase.getAllLogs();

    if (localLogs.isEmpty && allRemoteLogs.isNotEmpty) {
      await _habitUsecase.updateLogsList(allRemoteLogs);
    } else if (allRemoteLogs.isEmpty && localLogs.isNotEmpty) {
      await _syncLocalLogsToRemote(localLogs);
    } else if (allRemoteLogs.length > localLogs.length) {
      await _habitUsecase.updateLogsList(allRemoteLogs);
    } else if (localLogs.length > allRemoteLogs.length) {
      await _syncLocalLogsToRemote(localLogs);
    }
  }

  Future<void> _syncLocalLogsToRemote(
    final List<HabitLogEntity> localLogs,
  ) async {
    final Map<String, List<HabitLogEntity>> logsByHabit = {};

    for (final log in localLogs) {
      if (!logsByHabit.containsKey(log.habitId)) {
        logsByHabit[log.habitId] = [];
      }
      logsByHabit[log.habitId]!.add(log);
    }

    final List<Future<void>> uploadTasks = logsByHabit.entries.map((
      entry,
    ) async {
      final String habitId = entry.key;
      final List<HabitLogEntity> logs = entry.value;

      for (final log in logs) {
        await _remoteUsecase.saveLog(habitId: habitId, log: log);
      }
    }).toList();

    await Future.wait(uploadTasks);
  }

  Future<List<HabitWithLog>> _fetchHabitsWithLogs(final DateTime date) async {
    final List<CustomHabitEntity> habits = await _habitUsecase
        .getCustomHabits();
    final List<HabitLogEntity> logs = await _habitUsecase.getAllLogs();

    final Iterable<HabitLogEntity> logsForDate = logs.where(
      (log) => _isSameDay(log.date, date),
    );

    return habits.map((habit) {
      final String habitId = habit.id ?? _uuid.v4();

      final HabitLogEntity logForHabit = logsForDate.firstWhere(
        (log) => log.habitId == habitId,
        orElse: () => HabitLogEntity(
          id: '',
          habitId: habitId,
          date: date,
          goalValue: habit.goalValue,
        ),
      );

      return HabitWithLog(habit: habit, log: logForHabit);
    }).toList();
  }

  List<HabitLogEntity> _updateOrAddLog(
    final List<HabitLogEntity> logs,
    final HabitLogEntity updatedLog,
    final String logId,
  ) {
    final int index = logs.indexWhere((log) => log.id == logId);

    if (index != -1) {
      logs[index] = updatedLog;
    } else {
      logs.add(updatedLog);
    }

    return logs;
  }

  bool _isSameDay(final DateTime a, final DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
