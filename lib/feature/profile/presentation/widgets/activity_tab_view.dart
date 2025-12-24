import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/enums/activity_type.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/date_extensions.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';
import 'package:routiner/feature/profile/presentation/bloc/activity_tab_bloc/activity_tab_bloc.dart';

class ActivityTabView extends StatelessWidget {
  const ActivityTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivityTabBloc>(
      create: (context) =>
          AppInjector.getIt<ActivityTabBloc>()
            ..add(const LoadActivities(limit: 50)),
      child: const _ActivityTabContent(),
    );
  }
}

class _ActivityTabContent extends StatelessWidget {
  const _ActivityTabContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityTabBloc, ActivityTabState>(
      builder: (context, state) {
        if (state is ActivityTabLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ActivityTabError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: context.appColors.red),
              const SizedBox(height: 16),
              Text(state.message),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<ActivityTabBloc>().add(
                    const LoadActivities(limit: 50, forceRefresh: true),
                  );
                },
                child: Text(context.locale.retry),
              ),
            ],
          );
        }

        if (state is ActivityTabLoaded) {
          if (state.activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: context.appColors.slate,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No activities yet',
                    style: AppTextStyles.airbnbCerealW500S18Lh24.copyWith(
                      color: context.appColors.slate,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete habits to earn points!',
                    style: AppTextStyles.airbnbCerealW500S14Lh20.copyWith(
                      color: context.appColors.slate,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ActivityTabBloc>().add(
                const RefreshActivities(limit: 50),
              );
            },
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsetsGeometry.symmetric(
                    horizontal: 24,
                  ),
                  leading: Text(
                    context.locale.showingLastMonthActivity,
                    style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                      color: context.appColors.c040415,
                    ),
                  ),
                  trailing: SvgIconButton(
                    svgPath: AppAssets.filterIc,
                    onPressed: () {},
                    iconSize: 36,
                    padding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: state.activities.length,
                    itemBuilder: (context, index) {
                      final activity = state.activities[index];
                      return _ActivityTile(activity: activity);
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('Something went wrong'));
      },
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});

  final ActivityEntity activity;

  @override
  Widget build(final BuildContext context) {
    final ActivityType type = activity.activityType;

    return Container(
      margin: const EdgeInsetsGeometry.symmetric(vertical: 4),
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.appColors.black.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        tileColor: context.appColors.white,
        contentPadding: EdgeInsets.zero,
        title: Text(
          _buildTitle(context),
          style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
            color: context.appColors.c040415,
          ),
        ),
        subtitle: Text(
          activity.timestamp.formattedActivityTime(context),
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: SvgPicture.asset(type.path, width: 36, height: 36),
      ),
    );
  }

  String _buildTitle(BuildContext context) {
    final type = activity.activityType;

    if (type == ActivityType.habitCreated ||
        type == ActivityType.habitCompleted) {
      return '${activity.points} ${context.locale.pointsEarnedWithExclamation}';
    }

    return activity.description;
  }
}
