import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/enums/log_status.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/utils/toast_utils.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/habits_list/presentation/bloc/habits_list_bloc.dart';
import 'package:routiner/feature/home/domain/entity/habit_with_log.dart';
import 'package:routiner/feature/home/presentation/widgets/habit_card.dart';

@RoutePage()
class HabitsListScreen extends StatelessWidget {
  const HabitsListScreen({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<HabitsListBloc>(
      create: (_) =>
          AppInjector.getIt<HabitsListBloc>()..add(LoadHabitsForDate(date)),
      child: Scaffold(
        appBar: CustomAppBar(title: context.locale.habits),
        backgroundColor: context.appColors.cEAECF0,
        body: const _HabitsListStateView(),
      ),
    );
  }
}

class _HabitsListStateView extends StatelessWidget {
  const _HabitsListStateView();

  @override
  Widget build(final BuildContext context) {
    return BlocListener<HabitsListBloc, HabitsListState>(
      listenWhen: (previous, current) {
        if (previous is HabitsListLoaded && current is HabitsListLoaded) {
          return previous.errorMessage != current.errorMessage &&
              current.errorMessage != null;
        }
        return current is HabitsListLoaded && current.errorMessage != null;
      },
      listener: (context, state) {
        if (state is HabitsListLoaded && state.errorMessage != null) {
          ToastUtils.showToast(
            context,
            context.locale.habitStatusAlreadySet,
            success: false,
          );
        }
      },
      child: BlocBuilder<HabitsListBloc, HabitsListState>(
        builder: (final BuildContext context, final HabitsListState state) {
          if (state is HabitsListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HabitsListLoaded) {
            if (state.habitsWithLogs.isEmpty) {
              return const _EmptyView();
            }

            return _HabitsList(
              habits: state.habitsWithLogs.reversed.toList(),
              friendsCountMap: state.friendsCountMap,
            );
          }

          if (state is HabitsListError) {
            return _ErrorView(
              message: context.locale.habitLoadError(state.message),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _HabitsList extends StatelessWidget {
  const _HabitsList({required this.habits, required this.friendsCountMap});

  final List<HabitWithLog> habits;
  final Map<String, int> friendsCountMap;

  @override
  Widget build(final BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HabitsListBloc>().add(const RefreshHabits());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: habits.length,
        itemBuilder: (_, final int index) {
          final HabitWithLog habitWithLog = habits[index];
          final String? habitId = habitWithLog.habit.id;
          final int friendsCount = habitId != null
              ? (friendsCountMap[habitId] ?? 0)
              : 0;
          return HabitCard(
            habitWithLog: habitWithLog,
            friendsCount: friendsCount,
            onValueUpdated: () {
              context.read<HabitsListBloc>().add(const RefreshHabits());
            },
            onStatusChange:
                (final LogStatus status, final int? completedValue) {
                  context.read<HabitsListBloc>().add(
                    UpdateHabitLogStatus(
                      log: habitWithLog.log,
                      status: status,
                      completedValue: completedValue,
                    ),
                  );
                },
          );
        },
      ),
    );
  }
}

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
              context.read<HabitsListBloc>().add(const RefreshHabits()),
          child: Text(context.locale.retry),
        ),
      ],
    );
  }
}
