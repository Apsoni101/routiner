import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/activity/presentation/bloc/monthly_activity_bloc/monthly_activity_bloc.dart';
import 'package:routiner/feature/activity/presentation/widgets/activity_chart_container.dart';
import 'package:routiner/feature/activity/presentation/widgets/habit_summary_expansion_tile.dart';
import 'package:routiner/feature/activity/presentation/widgets/mood_chart_container.dart';
import 'package:routiner/feature/activity/presentation/widgets/mood_chart_widget.dart';

class MonthlyActivityView extends StatelessWidget {
  const MonthlyActivityView({
    required this.month,
    required this.year,
    super.key,
  });

  final int month;
  final int year;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<MonthlyActivityBloc>(
      create: (final BuildContext context) =>
      AppInjector.getIt<MonthlyActivityBloc>()
        ..add(MonthlyActivityMonthChanged(month: month, year: year)),
      child: BlocBuilder<MonthlyActivityBloc, MonthlyActivityState>(
        builder:
            (final BuildContext context, final MonthlyActivityState state) {
          if (state.month != month || state.year != year) {
            context.read<MonthlyActivityBloc>().add(
              MonthlyActivityMonthChanged(month: month, year: year),
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
                subtitle: context.locale.comparisonByMonth,
                isLoading: state.isLoading,
                chartData: state.chartData,
                emptyMessage: context.locale.noHabitsForDay,
              ),
              const SizedBox(height: 16),
              MoodChartContainer(
                title: 'Mood',
                subtitle: 'Average mood by week',
                isLoading: state.isLoading,
                moodChartData: state.moodChartData,
                timeFrameType: TimeFrameType.monthly,
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