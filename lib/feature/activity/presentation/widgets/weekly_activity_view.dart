import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/activity/presentation/bloc/weekly_activity_bloc/weekly_activity_bloc.dart';
import 'package:routiner/feature/activity/presentation/widgets/activity_chart_container.dart';
import 'package:routiner/feature/activity/presentation/widgets/habit_summary_expansion_tile.dart';
import 'package:routiner/feature/activity/presentation/widgets/mood_chart_container.dart';
import 'package:routiner/feature/activity/presentation/widgets/mood_chart_widget.dart';

class WeeklyActivityView extends StatelessWidget {
  const WeeklyActivityView({
    required this.startDate,
    required this.endDate,
    super.key,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<WeeklyActivityBloc>(
      create: (final BuildContext context) =>
      AppInjector.getIt<WeeklyActivityBloc>()..add(
        WeeklyActivityWeekChanged(startDate: startDate, endDate: endDate),
      ),
      child: BlocBuilder<WeeklyActivityBloc, WeeklyActivityState>(
        builder: (final BuildContext context, final WeeklyActivityState state) {
          if (state.startDate != startDate || state.endDate != endDate) {
            context.read<WeeklyActivityBloc>().add(
              WeeklyActivityWeekChanged(startDate: startDate, endDate: endDate),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              HabitSummaryExpansionTile(
                summary: state.summary,
                isLoading: state.isLoading,
              ),
              const SizedBox(height: 16),
              ActivityChartContainer(
                title: context.locale.habits,
                subtitle: context.locale.comparisonByWeek,
                isLoading: state.isLoading,
                chartData: state.chartData,
                emptyMessage: context.locale.noHabitsForDay,
              ),
              const SizedBox(height: 16),
              MoodChartContainer(
                title: context.locale.happy,
                subtitle: context.locale.avgMood,
                isLoading: state.isLoading,
                moodChartData: state.moodChartData,
                timeFrameType: TimeFrameType.weekly,
                emptyMessage: 'No mood data available',
              ),
              const SizedBox(height: 120),

            ],
          );
        },
      ),
    );
  }
}