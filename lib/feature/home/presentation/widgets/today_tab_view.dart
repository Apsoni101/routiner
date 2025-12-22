// lib/feature/home/presentation/widgets/today_tab_view.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/enums/log_status.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/home/domain/entity/habit_with_log.dart';
import 'package:routiner/feature/home/presentation/bloc/habit_display_bloc/habit_display_bloc.dart';
import 'package:routiner/feature/home/presentation/widgets/date_selector.dart';
import 'package:routiner/feature/home/presentation/widgets/habit_card.dart';
import 'package:routiner/feature/home/presentation/widgets/section_header.dart';

/// ------------------------------------------------------------
/// ROOT
/// ------------------------------------------------------------
class TodayTabView extends StatelessWidget {
  const TodayTabView({super.key, this.onHabitChanged});

  final void Function(VoidCallback)? onHabitChanged;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<HabitDisplayBloc>(
      create: (_) =>
          AppInjector.getIt<HabitDisplayBloc>()
            ..add(LoadHabitsForDate(DateTime.now())),
      child: _TodayTabContent(onHabitChanged: onHabitChanged),
    );
  }
}

/// ------------------------------------------------------------
/// CONTENT (DATE + LIST)
/// ------------------------------------------------------------

class _TodayTabContent extends StatefulWidget {
  const _TodayTabContent({this.onHabitChanged});

  final void Function(VoidCallback)? onHabitChanged;

  @override
  State<_TodayTabContent> createState() => _TodayTabContentState();
}

class _TodayTabContentState extends State<_TodayTabContent> {
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier<DateTime>(
    DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    widget.onHabitChanged?.call(_refreshHabits);
  }

  void _refreshHabits() {
    context.read<HabitDisplayBloc>().add(
      LoadHabitsForDate(_selectedDate.value),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 120),
      children: <Widget>[
        MonthDateSelector(
          onDateSelected: (final DateTime date) {
            _selectedDate.value = date;

            context.read<HabitDisplayBloc>().add(LoadHabitsForDate(date));
          },
        ),
        const _ProgressCard(),

        SectionHeader(
          title: context.locale.challenges,
          actionText: context.locale.viewAll,
          onActionPressed: () {},
        ),
        SectionHeader(
          title: context.locale.habits,
          actionText: context.locale.viewAll,
          onActionPressed: () async {
            await context.router.push(
              HabitsListRoute(date: _selectedDate.value),
            );

            if (!context.mounted) return;

            context.read<HabitDisplayBloc>().add(
              LoadHabitsForDate(_selectedDate.value),
            );
          },
        ),

        const _HabitStateView(),
      ],
    );
  }
}

/// ------------------------------------------------------------
/// PROGRESS CARD
/// ------------------------------------------------------------
class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  Future<void> _hideAfter30Seconds() async {
    await Future<void>.delayed(const Duration(seconds: 30));
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<void>(
      future: _hideAfter30Seconds(),
      builder:
          (final BuildContext context, final AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const SizedBox.shrink();
            }

            return BlocBuilder<HabitDisplayBloc, HabitDisplayState>(
              builder:
                  (final BuildContext context, final HabitDisplayState state) {
                    if (state is! HabitDisplayLoaded) {
                      return const SizedBox.shrink();
                    }

                    final int totalHabits = state.habitsWithLogs.length;
                    final int completedHabits = state.habitsWithLogs
                        .where(
                          (final HabitWithLog habit) =>
                              habit.log.status == LogStatus.completed,
                        )
                        .length;

                    if (totalHabits == 0) {
                      return const SizedBox.shrink();
                    }

                    final double progressValue = completedHabits / totalHabits;
                    final int progressPercentage = (progressValue * 100)
                        .round();

                    String titleText;
                    String emoji;

                    if (completedHabits == 0) {
                      titleText = context.locale.dailyGoalsStart;
                      emoji = '💪';
                    } else if (completedHabits == totalHabits) {
                      titleText = context.locale.dailyGoalsCompleted;
                      emoji = '🎉';
                    } else {
                      titleText = context.locale.dailyGoalsAlmostDone;
                      emoji = '🔥';
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: context.appColors.c000DFF,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(
                                value: progressValue,
                                color: context.appColors.white,
                                backgroundColor: context.appColors.white
                                    .withValues(alpha: 0.4),
                                strokeWidth: 2,
                              ),
                              Text(
                                '$progressPercentage%',
                                style: AppTextStyles.airbnbCerealW400S14Lh20Ls0
                                    .copyWith(
                                      color: context.appColors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        title: Text(
                          '$titleText $emoji',
                          style: AppTextStyles.airbnbCerealW500S14Lh20Ls0
                              .copyWith(color: context.appColors.white),
                        ),
                        subtitle: Text(
                          '$completedHabits of $totalHabits completed',
                          style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                            color: context.appColors.cAFB4FF,
                          ),
                        ),
                      ),
                    );
                  },
            );
          },
    );
  }
}

/// ------------------------------------------------------------
/// STATE VIEW
/// ------------------------------------------------------------
class _HabitStateView extends StatelessWidget {
  const _HabitStateView();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<HabitDisplayBloc, HabitDisplayState>(
      builder: (final BuildContext context, final HabitDisplayState state) {
        if (state is HabitDisplayLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HabitDisplayError) {
          return _ErrorView(
            message: context.locale.habitLoadError(state.message),
          );
        }

        if (state is HabitDisplayLoaded) {
          if (state.habitsWithLogs.isEmpty) {
            return const _EmptyView();
          }

          return _HabitList(
            habits: state.habitsWithLogs.reversed.toList(),
            friendsCountMap: state.friendsCountMap,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// ------------------------------------------------------------
/// ERROR
/// ------------------------------------------------------------
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) {
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error_outline, size: 64, color: context.appColors.red),
        Text(message),
        ElevatedButton(
          onPressed: () =>
              context.read<HabitDisplayBloc>().add(const RefreshHabits()),
          child: Text(context.locale.retry),
        ),
      ],
    );
  }
}

/// ------------------------------------------------------------
/// EMPTY
/// ------------------------------------------------------------
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(final BuildContext context) {
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.event_available, size: 64, color: context.appColors.slate),
        Text(context.locale.noHabitsForDay),
      ],
    );
  }
}

/// ------------------------------------------------------------
/// HABIT LIST
/// ------------------------------------------------------------
class _HabitList extends StatelessWidget {
  const _HabitList({required this.habits, required this.friendsCountMap});

  final List<HabitWithLog> habits;
  final Map<String, int> friendsCountMap;

  @override
  Widget build(final BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: habits.length > 5 ? 5 : habits.length,
      itemBuilder: (_, final int index) {
        final HabitWithLog habitWithLog = habits[index];
        final String habitId = habitWithLog.habit.id ?? '';
        final int friendsCount = friendsCountMap[habitId] ?? 0;

        return HabitCard(
          habitWithLog: habitWithLog,
          friendsCount: friendsCount,
          onValueUpdated: () {
            context.read<HabitDisplayBloc>().add(const RefreshHabits());
          },
          onStatusChange:
              (final LogStatus status, final int? completedValue) {
                context.read<HabitDisplayBloc>().add(
                  UpdateHabitLogStatus(
                    log: habitWithLog.log,
                    status: status,
                    completedValue: completedValue,
                  ),
                );
              },
        );
      },
    );
  }
}
