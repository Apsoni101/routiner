import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:routiner/core/enums/log_status.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/habits_list/domain/use_case/habits_list_local_usecase.dart';
import 'package:routiner/feature/habits_list/domain/use_case/habits_list_remote_usecase.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_with_log.dart';
import 'package:uuid/uuid.dart';

part 'habits_list_event.dart';
part 'habits_list_state.dart';

class HabitsListBloc extends Bloc<HabitsListEvent, HabitsListState> {
  HabitsListBloc({
    required final HabitsListLocalUsecase localUsecase,
    required final HabitsListRemoteUsecase remoteUsecase,
  }) : _local = localUsecase,
        _remote = remoteUsecase,
        super(HabitsListInitial()) {
    on<LoadHabitsForDate>(_loadHabits);
    on<UpdateHabitLogStatus>(_updateHabitLog);
    on<RefreshHabits>(_refreshHabits);
  }

  final HabitsListLocalUsecase _local;
  final HabitsListRemoteUsecase _remote;

  final Uuid _uuid = const Uuid();
  DateTime _currentDate = DateTime.now();

  /// --------------------------------------------------
  /// LOAD HABITS FOR DATE
  /// --------------------------------------------------

  Future<void> _loadHabits(
      final LoadHabitsForDate event,
      final Emitter<HabitsListState> emit,
      ) async {
    _currentDate = event.date;
    emit(HabitsListLoading());

    // 1. Load habits with logs
    final List<HabitWithLog> localHabits = await _fetchHabitsWithLogs(
      _currentDate,
    );

    // 2. Load cached friends count from local storage
    final Map<String, int> cachedFriendsCounts = await _local
        .getAllFriendsCounts();

    // 3. Emit loaded state with local data ONCE
    emit(
      HabitsListLoaded(
        habitsWithLogs: localHabits,
        selectedDate: _currentDate,
        friendsCountMap: Map<String, int>.from(cachedFriendsCounts),
      ),
    );

    // 4. Start background tasks without awaiting
    _syncInBackground(localHabits, cachedFriendsCounts, emit);
  }

  /// --------------------------------------------------
  /// SYNC IN BACKGROUND (Non-blocking)
  /// --------------------------------------------------

  Future<void> _syncInBackground(
      final List<HabitWithLog> habits,
      final Map<String, int> cachedCounts,
      final Emitter<HabitsListState> emit,
      ) async {
    // Run both tasks in parallel
    await Future.wait([
      _fetchAndCompareFriendsCount(habits, cachedCounts, emit),
      _syncWithRemote(),
    ]);

    // After both complete, emit final state once
    final List<HabitWithLog> syncedHabits = await _fetchHabitsWithLogs(
      _currentDate,
    );

    final Map<String, int> finalFriendsCounts = await _local
        .getAllFriendsCounts();

    // Only emit if state hasn't been closed
    if (!emit.isDone) {
      emit(
        HabitsListLoaded(
          habitsWithLogs: syncedHabits,
          selectedDate: _currentDate,
          friendsCountMap: Map<String, int>.from(finalFriendsCounts),
        ),
      );
    }
  }

  /// --------------------------------------------------
  /// FETCH AND COMPARE FRIENDS COUNT (Parallel)
  /// --------------------------------------------------

  Future<void> _fetchAndCompareFriendsCount(
      final List<HabitWithLog> habits,
      final Map<String, int> cachedCounts,
      final Emitter<HabitsListState> emit,
      ) async {
    // Create futures for all habits at once (parallel execution)
    final List<Future<void>> fetchTasks = habits.map((habitWithLog) {
      return _fetchSingleHabitFriendsCount(
        habitWithLog,
        cachedCounts,
      );
    }).toList();

    // Wait for all to complete
    await Future.wait(fetchTasks);

    // Get updated counts after all fetches
    final Map<String, int> updatedCounts = await _local
        .getAllFriendsCounts();

    // Check if any count actually changed
    bool hasChanges = false;
    for (final habitWithLog in habits) {
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

    // Only emit if something changed and state is still active
    if (hasChanges && !emit.isDone) {
      final List<HabitWithLog> currentHabits = await _fetchHabitsWithLogs(
        _currentDate,
      );

      emit(
        HabitsListLoaded(
          habitsWithLogs: currentHabits,
          selectedDate: _currentDate,
          friendsCountMap: Map<String, int>.from(updatedCounts),
        ),
      );
    }
  }

  /// --------------------------------------------------
  /// FETCH SINGLE HABIT FRIENDS COUNT
  /// --------------------------------------------------

  Future<void> _fetchSingleHabitFriendsCount(
      final HabitWithLog habitWithLog,
      final Map<String, int> cachedCounts,
      ) async {
    final String? habitName = habitWithLog.habit.name;
    final String? habitId = habitWithLog.habit.id;

    if (habitName == null || habitName.isEmpty || habitId == null) {
      return;
    }

    try {
      final Either<Failure, int> result = await _remote
          .getFriendsWithSameGoalCount(habitName: habitName);

      await result.fold(
            (final Failure failure) async {
          // On failure, ensure we have a value (either cached or 0)
          if (!cachedCounts.containsKey(habitId)) {
            await _local.saveFriendsCount(habitId, 0);
          }
        },
            (final int remoteCount) async {
          // Always save the remote count
          await _local.saveFriendsCount(habitId, remoteCount);
        },
      );
    } catch (e) {
      // Handle any exceptions
      if (!cachedCounts.containsKey(habitId)) {
        await _local.saveFriendsCount(habitId, 0);
      }
    }
  }

  /// --------------------------------------------------
  /// UPDATE HABIT LOG
  /// --------------------------------------------------

  Future<void> _updateHabitLog(
      final UpdateHabitLogStatus event,
      final Emitter<HabitsListState> emit,
      ) async {
    final String logId = (event.log.id == null || event.log.id!.isEmpty)
        ? _uuid.v4()
        : event.log.id!;

    final HabitLogEntity updatedLog = event.log.copyWith(
      id: logId,
      status: event.status,
      completedValue: event.completedValue,
      completedAt: event.status == LogStatus.completed ? DateTime.now() : null,
    );

    final List<HabitLogEntity> logs = await _local.getAllLogs();
    final int index = logs.indexWhere(
          (final HabitLogEntity l) => l.id == logId,
    );

    if (index != -1) {
      logs[index] = updatedLog;
    } else {
      logs.add(updatedLog);
    }

    await _local.updateLogsList(logs);
    await _local.saveLogById(logId, updatedLog);

    // Emit updated state immediately with current friends counts
    final Map<String, int> friendsCounts = await _local.getAllFriendsCounts();

    emit(
      HabitsListLoaded(
        habitsWithLogs: await _fetchHabitsWithLogs(_currentDate),
        selectedDate: _currentDate,
        friendsCountMap: Map<String, int>.from(friendsCounts),
      ),
    );

    // Sync to remote in the background (don't await)
    _remote.saveLog(habitId: updatedLog.habitId, log: updatedLog);
  }

  /// --------------------------------------------------
  /// REFRESH HABITS
  /// --------------------------------------------------

  Future<void> _refreshHabits(
      final RefreshHabits event,
      final Emitter<HabitsListState> emit,
      ) async {
    final List<HabitWithLog> local = await _fetchHabitsWithLogs(_currentDate);
    final Map<String, int> friendsCounts = await _local.getAllFriendsCounts();

    emit(
      HabitsListLoaded(
        habitsWithLogs: local,
        selectedDate: _currentDate,
        friendsCountMap: Map<String, int>.from(friendsCounts),
      ),
    );

    add(LoadHabitsForDate(_currentDate));
  }

  /// --------------------------------------------------
  /// SYNC WITH REMOTE
  /// --------------------------------------------------

  Future<void> _syncWithRemote() async {
    final List<CustomHabitEntity> habits = await _local.getCustomHabits();
    final Map<String, List<HabitLogEntity>> remoteLogsByHabit =
    <String, List<HabitLogEntity>>{};
    final List<HabitLogEntity> allRemoteLogs = <HabitLogEntity>[];

    // Fetch remote logs for all habits in parallel
    final List<Future<void>> fetchTasks = habits
        .where((habit) => habit.id != null && habit.id!.isNotEmpty)
        .map((habit) async {
      try {
        final Either<Failure, List<HabitLogEntity>> remoteResult =
        await _remote.getLogsForHabit(habitId: habit.id!);

        await remoteResult.fold(
              (final Failure _) async {
            // Handle failure silently
          },
              (final List<HabitLogEntity> logs) async {
            remoteLogsByHabit[habit.id!] = logs;
            allRemoteLogs.addAll(logs);
          },
        );
      } catch (e) {
        // Handle any exceptions
      }
    }).toList();

    await Future.wait(fetchTasks);

    final List<HabitLogEntity> localLogs = await _local.getAllLogs();

    // Sync logic: choose the source with more data
    if (localLogs.isEmpty && allRemoteLogs.isNotEmpty) {
      await _local.updateLogsList(allRemoteLogs);
    } else if (allRemoteLogs.isEmpty && localLogs.isNotEmpty) {
      await _syncLocalLogsToRemote(localLogs);
    } else if (allRemoteLogs.length > localLogs.length) {
      await _local.updateLogsList(allRemoteLogs);
    } else if (localLogs.length > allRemoteLogs.length) {
      await _syncLocalLogsToRemote(localLogs);
    }
  }

  /// --------------------------------------------------
  /// FETCH HABITS WITH LOGS
  /// --------------------------------------------------

  Future<List<HabitWithLog>> _fetchHabitsWithLogs(final DateTime date) async {
    final List<CustomHabitEntity> habits = await _local.getCustomHabits();
    final List<HabitLogEntity> logs = await _local.getAllLogs();

    return habits.map((final CustomHabitEntity habit) {
      final String habitId = habit.id ?? _uuid.v4();

      final HabitLogEntity log = logs.firstWhere(
            (final HabitLogEntity l) =>
        l.habitId == habitId && _isSameDay(l.date, date),
        orElse: () => HabitLogEntity(
          id: '',
          habitId: habitId,
          date: date,
          goalValue: habit.goalValue,
        ),
      );

      return HabitWithLog(habit: habit, log: log);
    }).toList();
  }

  /// --------------------------------------------------
  /// SYNC LOCAL LOGS TO REMOTE
  /// --------------------------------------------------

  Future<void> _syncLocalLogsToRemote(
      final List<HabitLogEntity> localLogs,
      ) async {
    final Map<String, List<HabitLogEntity>> logsByHabit =
    <String, List<HabitLogEntity>>{};

    for (final HabitLogEntity log in localLogs) {
      if (!logsByHabit.containsKey(log.habitId)) {
        logsByHabit[log.habitId] = <HabitLogEntity>[];
      }
      logsByHabit[log.habitId]!.add(log);
    }

    // Upload logs in parallel (batch by habit)
    final List<Future<void>> uploadTasks = logsByHabit.entries.map((entry) async {
      final String habitId = entry.key;
      final List<HabitLogEntity> logs = entry.value;

      for (final HabitLogEntity log in logs) {
        try {
          await _remote.saveLog(habitId: habitId, log: log);
        } catch (e) {
          // Handle failure silently
        }
      }
    }).toList();

    await Future.wait(uploadTasks);
  }

  /// --------------------------------------------------
  /// DATE COMPARISON
  /// --------------------------------------------------

  bool _isSameDay(final DateTime a, final DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}