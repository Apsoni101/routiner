import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/activity/presentation/bloc/daily_activity_bloc/daily_activity_bloc.dart';
import 'package:routiner/feature/activity/presentation/widgets/activity_chart_container.dart';
import 'package:routiner/feature/activity/presentation/widgets/habit_summary_expansion_tile.dart';
import 'package:routiner/feature/activity/presentation/widgets/mood_chart_container.dart';
import 'package:routiner/feature/activity/presentation/widgets/mood_chart_widget.dart';

class DailyActivityView extends StatelessWidget {
  const DailyActivityView({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<DailyActivityBloc>(
      create: (final BuildContext context) =>
          AppInjector.getIt<DailyActivityBloc>()
            ..add(DailyActivityDateChanged(date)),
      child: BlocBuilder<DailyActivityBloc, DailyActivityState>(
        builder: (final BuildContext context, final DailyActivityState state) {
          if (state.currentDate != date) {
            context.read<DailyActivityBloc>().add(
              DailyActivityDateChanged(date),
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
                subtitle: context.locale.comparisonByDay,
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
                timeFrameType: TimeFrameType.daily,
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
