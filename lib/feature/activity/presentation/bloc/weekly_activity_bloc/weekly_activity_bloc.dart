import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:routiner/core/enums/moods.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/activity/domain/entity/activity_summary_entity.dart';
import 'package:routiner/feature/activity/domain/entity/chart_data_point_entity.dart';
import 'package:routiner/feature/activity/domain/entity/mood_chart_data_point.dart';
import 'package:routiner/feature/activity/domain/usecase/activity_local_use_case.dart';
import 'package:routiner/feature/activity/domain/usecase/activity_remote_usecase.dart';
import 'package:routiner/feature/activity/presentation/widgets/activity_chart.dart';
import 'package:routiner/feature/activity/presentation/widgets/mood_chart_widget.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';

part 'weekly_activity_event.dart';
part 'weekly_activity_state.dart';

class WeeklyActivityBloc extends Bloc<WeeklyActivityEvent, WeeklyActivityState> {
  WeeklyActivityBloc({
    required this.activityRemoteUseCase,
    required this.activityLocalUseCase,
  }) : super(const WeeklyActivityState()) {
    on<WeeklyActivityWeekChanged>(_onWeekChanged);
    on<WeeklyActivitySummaryRequested>(_onSummaryRequested);
  }

  final ActivityRemoteUseCase activityRemoteUseCase;
  final ActivityLocalUseCase activityLocalUseCase;

  Future<void> _onWeekChanged(
      final WeeklyActivityWeekChanged event,
      final Emitter<WeeklyActivityState> emit,
      ) async {
    emit(
      state.copyWith(
        startDate: event.startDate,
        endDate: event.endDate,
        isLoading: true,
      ),
    );

    await _fetchAndCalculateSummary(event.startDate, event.endDate, emit);
  }

  Future<void> _onSummaryRequested(
      final WeeklyActivitySummaryRequested event,
      final Emitter<WeeklyActivityState> emit,
      ) async {
    if (state.startDate == null || state.endDate == null) {
      return;
    }

    emit(state.copyWith(isLoading: true));
    await _fetchAndCalculateSummary(state.startDate!, state.endDate!, emit);
  }

  Future<void> _fetchAndCalculateSummary(
      final DateTime startDate,
      final DateTime endDate,
      final Emitter<WeeklyActivityState> emit,
      ) async {
    // EXISTING - Fetch habit logs
    final Either<Failure, List<Map<String, dynamic>>> logsResult =
    await activityRemoteUseCase.getHabitLogs(
      startDate: startDate,
      endDate: endDate,
    );

    // NEW - Fetch mood data (try local first, then remote)
    List<MoodLogEntity> moodLogs = activityLocalUseCase.getMoodLogs(
      startDate: startDate,
      endDate: endDate,
    );

    if (moodLogs.isEmpty) {
      final moodResult = await activityRemoteUseCase.getMoodLogs(
        startDate: startDate,
        endDate: endDate,
      );
      moodResult.fold(
            (failure) => moodLogs = [],
            (remoteLogs) => moodLogs = remoteLogs,
      );
    }

    // EXISTING - Process habit logs
    await logsResult.fold(
          (final Failure failure) async {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
          (final List<Map<String, dynamic>> logs) async {
        final ActivitySummaryEntity summary = _calculateWeeklySummary(logs);
        final List<ChartDataPoint> chartData =
        _generateChartData(logs, startDate, endDate);

        // NEW - Generate mood chart data
        final List<MoodChartDataPoint> moodChartData =
        _generateMoodChartData(moodLogs, startDate, endDate);

        emit(state.copyWith(
          summary: summary,
          chartData: chartData,
          moodChartData: moodChartData,
          isLoading: false,
        ));
      },
    );
  }

  // EXISTING METHOD - No changes
  ActivitySummaryEntity _calculateWeeklySummary(
      final List<Map<String, dynamic>> logs,
      ) {
    if (logs.isEmpty) {
      return const ActivitySummaryEntity(
        successRate: 0,
        completed: 0,
        failed: 0,
        skipped: 0,
        bestStreakDay: 0,
        pointsEarned: 0,
      );
    }

    int completed = 0;
    int failed = 0;
    int skipped = 0;

    for (final Map<String, dynamic> log in logs) {
      final String? status = log['status']?.toString().toLowerCase();
      switch (status) {
        case 'completed':
          completed++;
          break;
        case 'failed':
          failed++;
          break;
        case 'skipped':
          skipped++;
          break;
      }
    }

    final int total = completed + failed + skipped;
    final double successRate = total > 0 ? (completed / total) * 100 : 0.0;

    return ActivitySummaryEntity(
      successRate: successRate,
      completed: completed,
      failed: failed,
      skipped: skipped,
      bestStreakDay: _calculateBestStreakInWeek(logs),
      pointsEarned: completed * 10,
    );
  }

  // EXISTING METHOD - No changes
  List<ChartDataPoint> _generateChartData(
      final List<Map<String, dynamic>> logs,
      final DateTime startDate,
      final DateTime endDate,
      ) {
    final List<ChartDataPoint> chartData = [];
    final DateTime today = DateTime.now();

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final DateTime currentDate = startDate.add(Duration(days: i));

      final List<Map<String, dynamic>> dayLogs = logs.where((log) {
        final String? dateStr = log['date']?.toString();
        if (dateStr == null) return false;
        try {
          final DateTime logDate = DateTime.parse(dateStr);
          return logDate.year == currentDate.year &&
              logDate.month == currentDate.month &&
              logDate.day == currentDate.day;
        } catch (e) {
          return false;
        }
      }).toList();

      int completed = 0;
      int total = dayLogs.length;

      for (final Map<String, dynamic> log in dayLogs) {
        final String? status = log['status']?.toString().toLowerCase();
        if (status == 'completed') {
          completed++;
        }
      }

      final bool isToday = currentDate.year == today.year &&
          currentDate.month == today.month &&
          currentDate.day == today.day;

      chartData.add(
        ChartDataPoint(
          label: '${currentDate.day}',
          completedTasks: completed,
          totalTasks: total > 0 ? total : 0,
          isToday: isToday,
        ),
      );
    }

    return chartData;
  }

  // NEW METHOD - For mood chart data
  List<MoodChartDataPoint> _generateMoodChartData(
      final List<MoodLogEntity> moodLogs,
      final DateTime startDate,
      final DateTime endDate,
      ) {
    final List<MoodChartDataPoint> moodChartData = [];
    final DateTime today = DateTime.now();

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final DateTime currentDate = startDate.add(Duration(days: i));

      final MoodLogEntity? dayMoodLog =
      moodLogs.cast<MoodLogEntity?>().firstWhere(
            (log) {
          if (log == null) return false;
          return log.timestamp.year == currentDate.year &&
              log.timestamp.month == currentDate.month &&
              log.timestamp.day == currentDate.day;
        },
        orElse: () => null,
      );

      final bool isToday = currentDate.year == today.year &&
          currentDate.month == today.month &&
          currentDate.day == today.day;

      moodChartData.add(
        MoodChartDataPoint(
          label: '${currentDate.day}',
          dateTime: currentDate,
          mood: dayMoodLog != null ? Mood.fromString(dayMoodLog.mood) : null,
          isToday: isToday,
        ),
      );
    }

    return moodChartData;
  }

  // EXISTING METHOD - No changes
  int _calculateBestStreakInWeek(final List<Map<String, dynamic>> logs) {
    final Map<String, int> dailyCompleted = <String, int>{};

    for (final Map<String, dynamic> log in logs) {
      final String? status = log['status']?.toString().toLowerCase();
      final String? dateStr = log['date']?.toString();
      if (status == 'completed' && dateStr != null && dateStr.isNotEmpty) {
        dailyCompleted[dateStr] = (dailyCompleted[dateStr] ?? 0) + 1;
      }
    }

    final List<String> sortedDates = dailyCompleted.keys.toList()..sort();

    int maxStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (final String dateStr in sortedDates) {
      try {
        final DateTime currentDate = DateTime.parse(dateStr);

        if (lastDate == null || currentDate.difference(lastDate).inDays == 1) {
          currentStreak++;
          maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
        } else {
          currentStreak = 1;
        }

        lastDate = currentDate;
      } catch (e) {
        continue;
      }
    }

    return maxStreak;
  }
}