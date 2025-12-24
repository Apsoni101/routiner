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
import 'package:routiner/core/utils/toast_utils.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/presentation/widgets/challenge_card.dart';
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
      create: (_) => AppInjector.getIt<HabitDisplayBloc>()
        ..add(LoadHabitsForDate(DateTime.now()))
        ..add(const LoadChallenges()),
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
    // LoadChallenges will be triggered automatically by LoadHabitsForDate
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
          onActionPressed: () async {
            await context.router.push(const ChallengesListRoute());

            if (!context.mounted) return;

            context.read<HabitDisplayBloc>().add(
              LoadHabitsForDate(_selectedDate.value),
            );
          },
        ),
        const _ChallengesSection(),

        // Habits Section
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
/// CHALLENGES SECTION
/// ------------------------------------------------------------
class _ChallengesSection extends StatelessWidget {
  const _ChallengesSection();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<HabitDisplayBloc, HabitDisplayState>(
      builder: (final BuildContext context, final HabitDisplayState state) {
        if (state is! HabitDisplayLoaded) {
          return const SizedBox.shrink();
        }

        // Show loading indicator
        if (state.challengesLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Show empty state with create challenge button
        if (state.challenges.isEmpty) {
          return _EmptyChallengesView();
        }

        // Show challenges list (limited to 3 items)
        return _ChallengesList(challenges: state.challenges);
      },
    );
  }
}

/// ------------------------------------------------------------
/// EMPTY CHALLENGES VIEW
/// ------------------------------------------------------------
class _EmptyChallengesView extends StatelessWidget {
  const _EmptyChallengesView();

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.cCDCDD0, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.emoji_events_outlined,
            size: 48,
            color: context.appColors.slate,
          ),
          const SizedBox(height: 12),
          Text(
            context.locale.noChallengesYet,
            style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
              color: context.appColors.cCDCDD0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            context.locale.createFirstChallenge,
            style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
              color: context.appColors.slate,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await context.router.push(const CreateChallengeRoute());

                if (!context.mounted) return;

                context.read<HabitDisplayBloc>().add(const LoadChallenges());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColors.c3843FF,
                foregroundColor: context.appColors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.add, color: context.appColors.white),
              label: Text(
                context.locale.createChallenge,
                style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                  color: context.appColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------
/// CHALLENGES LIST
/// ------------------------------------------------------------
class _ChallengesList extends StatelessWidget {
  const _ChallengesList({required this.challenges});

  final List<ChallengeEntity> challenges;

  @override
  Widget build(final BuildContext context) {
    final int itemCount = challenges.length > 3 ? 3 : challenges.length;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: itemCount,
      itemBuilder: (final BuildContext context, final int index) {
        return ChallengeCard(
          challenge: challenges[index],
          onRefresh: () {
            context.read<HabitDisplayBloc>().add(const LoadChallenges());
          },
        );
      },
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
    return BlocListener<HabitDisplayBloc, HabitDisplayState>(
      listenWhen: (previous, current) {
        // Always listen when errorMessage changes (including when it appears again)
        if (previous is HabitDisplayLoaded && current is HabitDisplayLoaded) {
          return previous.errorMessage != current.errorMessage &&
              current.errorMessage != null;
        }
        return current is HabitDisplayLoaded && current.errorMessage != null;
      },
      listener: (context, state) {
        if (state is HabitDisplayLoaded && state.errorMessage != null) {
          ToastUtils.showToast(
            context,
            context.locale.habitStatusAlreadySet,
            success: false,
          );
        }
      },
      child: BlocBuilder<HabitDisplayBloc, HabitDisplayState>(
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
      ),
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
      physics: const NeverScrollableScrollPhysics(),
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
          onStatusChange: (final LogStatus status, final int? completedValue) {
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
