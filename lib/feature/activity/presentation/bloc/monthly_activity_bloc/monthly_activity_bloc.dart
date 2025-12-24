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

part 'monthly_activity_event.dart';

part 'monthly_activity_state.dart';

class MonthlyActivityBloc
    extends Bloc<MonthlyActivityEvent, MonthlyActivityState> {
  MonthlyActivityBloc({
    required this.activityRemoteUseCase,
    required this.activityLocalUseCase,
  }) : super(const MonthlyActivityState()) {
    on<MonthlyActivityMonthChanged>(_onMonthChanged);
    on<MonthlyActivitySummaryRequested>(_onSummaryRequested);
  }

  final ActivityRemoteUseCase activityRemoteUseCase;
  final ActivityLocalUseCase activityLocalUseCase;

  Future<void> _onMonthChanged(
    final MonthlyActivityMonthChanged event,
    final Emitter<MonthlyActivityState> emit,
  ) async {
    emit(state.copyWith(month: event.month, year: event.year, isLoading: true));

    await _fetchAndCalculateSummary(event.month, event.year, emit);
  }

  Future<void> _onSummaryRequested(
    final MonthlyActivitySummaryRequested event,
    final Emitter<MonthlyActivityState> emit,
  ) async {
    if (state.month == null || state.year == null) {
      return;
    }

    emit(state.copyWith(isLoading: true));
    await _fetchAndCalculateSummary(state.month!, state.year!, emit);
  }

  Future<void> _fetchAndCalculateSummary(
    final int month,
    final int year,
    final Emitter<MonthlyActivityState> emit,
  ) async {
    final DateTime startDate = DateTime(year, month);
    final DateTime endDate = DateTime(year, month + 1, 0);

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
        final ActivitySummaryEntity summary = _calculateMonthlySummary(logs);
        final List<ChartDataPoint> chartData = _generateChartData(
          logs,
          startDate,
          endDate,
        );

        // NEW - Generate mood chart data for monthly view (grouped by weeks)
        final List<MoodChartDataPoint> moodChartData = _generateMoodChartData(
          moodLogs,
          startDate,
          endDate,
        );

        emit(
          state.copyWith(
            summary: summary,
            chartData: chartData,
            moodChartData: moodChartData,
            isLoading: false,
          ),
        );
      },
    );
  }

  // EXISTING METHOD - No changes
  ActivitySummaryEntity _calculateMonthlySummary(
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
      bestStreakDay: _calculateBestStreakInMonth(logs),
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

    // Group by weeks for monthly view
    final int totalDays = endDate.difference(startDate).inDays + 1;
    final int totalWeeks = (totalDays / 7).ceil();

    for (int weekIndex = 0; weekIndex < totalWeeks; weekIndex++) {
      final DateTime weekStart = startDate.add(Duration(days: weekIndex * 7));
      final DateTime weekEnd = weekStart.add(const Duration(days: 6));
      final DateTime actualWeekEnd = weekEnd.isAfter(endDate)
          ? endDate
          : weekEnd;

      final List<Map<String, dynamic>> weekLogs = logs.where((log) {
        final String? dateStr = log['date']?.toString();
        if (dateStr == null) return false;
        try {
          final DateTime logDate = DateTime.parse(dateStr);
          return (logDate.isAfter(
                weekStart.subtract(const Duration(days: 1)),
              ) &&
              logDate.isBefore(actualWeekEnd.add(const Duration(days: 1))));
        } catch (e) {
          return false;
        }
      }).toList();

      int completed = 0;
      int total = weekLogs.length;

      for (final Map<String, dynamic> log in weekLogs) {
        final String? status = log['status']?.toString().toLowerCase();
        if (status == 'completed') {
          completed++;
        }
      }

      final bool isCurrentWeek =
          (today.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          today.isBefore(actualWeekEnd.add(const Duration(days: 1))));

      chartData.add(
        ChartDataPoint(
          label: '${weekStart.day}',
          completedTasks: completed,
          totalTasks: total > 0 ? total : 0,
          isToday: isCurrentWeek,
        ),
      );
    }

    return chartData;
  }

  // NEW METHOD - For mood chart data (weekly aggregation for monthly view)
  List<MoodChartDataPoint> _generateMoodChartData(
    final List<MoodLogEntity> moodLogs,
    final DateTime startDate,
    final DateTime endDate,
  ) {
    final List<MoodChartDataPoint> moodChartData = [];
    final DateTime today = DateTime.now();

    // Group by weeks for monthly view
    final int totalDays = endDate.difference(startDate).inDays + 1;
    final int totalWeeks = (totalDays / 7).ceil();

    for (int weekIndex = 0; weekIndex < totalWeeks; weekIndex++) {
      final DateTime weekStart = startDate.add(Duration(days: weekIndex * 7));
      final DateTime weekEnd = weekStart.add(const Duration(days: 6));
      final DateTime actualWeekEnd = weekEnd.isAfter(endDate)
          ? endDate
          : weekEnd;

      // Get all moods for this week
      final List<MoodLogEntity> weekMoodLogs = moodLogs.where((log) {
        return log.timestamp.isAfter(
              weekStart.subtract(const Duration(days: 1)),
            ) &&
            log.timestamp.isBefore(actualWeekEnd.add(const Duration(days: 1)));
      }).toList();

      // Calculate average mood for the week
      Mood? averageMood;
      if (weekMoodLogs.isNotEmpty) {
        final moodValues = weekMoodLogs
            .map((log) => Mood.fromString(log.mood))
            .where((mood) => mood != null)
            .map((mood) => _moodToValue(mood!))
            .toList();

        if (moodValues.isNotEmpty) {
          final avgValue =
              moodValues.reduce((a, b) => a + b) / moodValues.length;
          averageMood = _valueToMood(avgValue.round());
        }
      }

      final bool isCurrentWeek =
          (today.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          today.isBefore(actualWeekEnd.add(const Duration(days: 1))));

      moodChartData.add(
        MoodChartDataPoint(
          label: '${weekStart.day}',
          dateTime: weekStart,
          mood: averageMood,
          isToday: isCurrentWeek,
        ),
      );
    }

    return moodChartData;
  }

  int _moodToValue(Mood mood) {
    switch (mood) {
      case Mood.angry:
        return 0;
      case Mood.sad:
        return 1;
      case Mood.neutral:
        return 2;
      case Mood.happy:
        return 3;
      case Mood.love:
        return 4;
    }
  }

  Mood _valueToMood(int value) {
    switch (value) {
      case 0:
        return Mood.angry;
      case 1:
        return Mood.sad;
      case 2:
        return Mood.neutral;
      case 3:
        return Mood.happy;
      case 4:
      default:
        return Mood.love;
    }
  }

  // EXISTING METHOD - No changes
  int _calculateBestStreakInMonth(final List<Map<String, dynamic>> logs) {
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
