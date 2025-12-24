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

part 'daily_activity_event.dart';
part 'daily_activity_state.dart';

class DailyActivityBloc extends Bloc<DailyActivityEvent, DailyActivityState> {
  DailyActivityBloc({
    required this.activityRemoteUseCase,
    required this.activityLocalUseCase,
  }) : super(DailyActivityState(currentDate: DateTime.now())) {
    on<DailyActivityDateChanged>(_onDateChanged);
    on<DailyActivitySummaryRequested>(_onSummaryRequested);
  }

  final ActivityRemoteUseCase activityRemoteUseCase;
  final ActivityLocalUseCase activityLocalUseCase;

  Future<void> _onDateChanged(
      final DailyActivityDateChanged event,
      final Emitter<DailyActivityState> emit,
      ) async {
    emit(state.copyWith(currentDate: event.date, isLoading: true));
    await _fetchAndCalculateSummary(event.date, emit);
  }

  Future<void> _onSummaryRequested(
      final DailyActivitySummaryRequested event,
      final Emitter<DailyActivityState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    await _fetchAndCalculateSummary(state.currentDate, emit);
  }

  Future<void> _fetchAndCalculateSummary(
      final DateTime date,
      final Emitter<DailyActivityState> emit,
      ) async {
    // Normalize date to remove time component (set to midnight)
    final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    final DateTime startDate = normalizedDate.subtract(const Duration(days: 6));
    // Set end date to end of day to capture all logs for today
    final DateTime endDate = DateTime(
      normalizedDate.year,
      normalizedDate.month,
      normalizedDate.day,
      23,
      59,
      59,
    );

    print('📅 Fetching data from $startDate to $endDate');
    print('📅 Normalized current date: $normalizedDate');

    final Either<Failure, List<Map<String, dynamic>>> logsResult =
    await activityRemoteUseCase.getHabitLogs(
      startDate: startDate,
      endDate: endDate,
    );

    // Fetch mood data (try local first, then remote)
    List<MoodLogEntity> moodLogs = activityLocalUseCase.getMoodLogs(
      startDate: startDate,
      endDate: endDate,
    );

    // If no local mood logs, fetch from remote
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

    print('📊 Found ${moodLogs.length} mood logs');

    // Process habit logs
    await logsResult.fold(
          (final Failure failure) async {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
          (final List<Map<String, dynamic>> logs) async {
        print('📊 Found ${logs.length} habit logs');

        final ActivitySummaryEntity summary =
        _calculateDailySummary(logs, normalizedDate);
        final List<ChartDataPoint> chartData =
        _generateChartData(logs, startDate, normalizedDate);

        // Generate mood chart data
        final List<MoodChartDataPoint> moodChartData =
        _generateMoodChartData(moodLogs, startDate, normalizedDate);

        emit(state.copyWith(
          summary: summary,
          chartData: chartData,
          moodChartData: moodChartData,
          isLoading: false,
        ));
      },
    );
  }

  ActivitySummaryEntity _calculateDailySummary(
      final List<Map<String, dynamic>> logs,
      final DateTime date,
      ) {
    // Normalize the target date
    final DateTime normalizedDate = DateTime(date.year, date.month, date.day);

    final List<Map<String, dynamic>> dayLogs =
    logs.where((final Map<String, dynamic> log) {
      final String? dateStr = log['date']?.toString();
      if (dateStr == null) {
        return false;
      }
      try {
        final DateTime logDate = DateTime.parse(dateStr);
        // Normalize log date for comparison
        final DateTime normalizedLogDate = DateTime(
          logDate.year,
          logDate.month,
          logDate.day,
        );
        return normalizedLogDate == normalizedDate;
      } catch (e) {
        print('⚠️ Error parsing date: $dateStr - $e');
        return false;
      }
    }).toList();

    print('📊 Found ${dayLogs.length} logs for ${normalizedDate.toString().split(' ')[0]}');

    if (dayLogs.isEmpty) {
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

    for (final Map<String, dynamic> log in dayLogs) {
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
      bestStreakDay: _calculateBestStreak(logs),
      pointsEarned: completed * 10,
    );
  }

  List<ChartDataPoint> _generateChartData(
      final List<Map<String, dynamic>> logs,
      final DateTime startDate,
      final DateTime endDate,
      ) {
    final List<ChartDataPoint> chartData = <ChartDataPoint>[];
    final DateTime today = DateTime.now();
    // Normalize today's date
    final DateTime normalizedToday = DateTime(today.year, today.month, today.day);

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final DateTime currentDate = startDate.add(Duration(days: i));
      // Normalize current date for comparison
      final DateTime normalizedCurrentDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );

      final List<Map<String, dynamic>> dayLogs =
      logs.where((final Map<String, dynamic> log) {
        final String? dateStr = log['date']?.toString();
        if (dateStr == null) {
          return false;
        }
        try {
          final DateTime logDate = DateTime.parse(dateStr);
          // Normalize log date for comparison
          final DateTime normalizedLogDate = DateTime(
            logDate.year,
            logDate.month,
            logDate.day,
          );
          return normalizedLogDate == normalizedCurrentDate;
        } catch (e) {
          print('⚠️ Error parsing date in chart: $dateStr - $e');
          return false;
        }
      }).toList();

      int completed = 0;
      final int total = dayLogs.length;

      for (final Map<String, dynamic> log in dayLogs) {
        final String? status = log['status']?.toString().toLowerCase();
        if (status == 'completed') {
          completed++;
        }
      }

      final bool isToday = normalizedCurrentDate == normalizedToday;

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

  List<MoodChartDataPoint> _generateMoodChartData(
      final List<MoodLogEntity> moodLogs,
      final DateTime startDate,
      final DateTime endDate,
      ) {
    final List<MoodChartDataPoint> moodChartData = [];
    final DateTime today = DateTime.now();
    // Normalize today's date
    final DateTime normalizedToday = DateTime(today.year, today.month, today.day);

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final DateTime currentDate = startDate.add(Duration(days: i));
      // Normalize current date for comparison
      final DateTime normalizedCurrentDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );

      // Find mood log for this date
      final MoodLogEntity? dayMoodLog =
      moodLogs.cast<MoodLogEntity?>().firstWhere(
            (log) {
          if (log == null) return false;
          // Normalize mood log date for comparison
          final DateTime normalizedMoodDate = DateTime(
            log.timestamp.year,
            log.timestamp.month,
            log.timestamp.day,
          );
          return normalizedMoodDate == normalizedCurrentDate;
        },
        orElse: () => null,
      );

      final bool isToday = normalizedCurrentDate == normalizedToday;

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

  int _calculateBestStreak(final List<Map<String, dynamic>> logs) {
    final Map<String, int> dailyCompleted = <String, int>{};

    for (final Map<String, dynamic> log in logs) {
      final String? status = log['status']?.toString().toLowerCase();
      final String? dateStr = log['date']?.toString();
      if (status == 'completed' && dateStr != null && dateStr.isNotEmpty) {
        try {
          final DateTime logDate = DateTime.parse(dateStr);
          // Normalize to date-only string for grouping
          final String normalizedDateStr =
              '${logDate.year}-${logDate.month.toString().padLeft(2, '0')}-${logDate.day.toString().padLeft(2, '0')}';
          dailyCompleted[normalizedDateStr] =
              (dailyCompleted[normalizedDateStr] ?? 0) + 1;
        } catch (e) {
          print('⚠️ Error parsing date in streak calculation: $dateStr - $e');
          continue;
        }
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
        print('⚠️ Error in streak calculation: $dateStr - $e');
        continue;
      }
    }

    return maxStreak;
  }
}