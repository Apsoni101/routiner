import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/date_extensions.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/activity/presentation/bloc/activity_bloc/activity_bloc.dart';
import 'package:routiner/feature/activity/presentation/widgets/dailly_activity_view.dart';
import 'package:routiner/feature/activity/presentation/widgets/monthly_activity_view.dart';
import 'package:routiner/feature/activity/presentation/widgets/weekly_activity_view.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';
import 'package:routiner/feature/home/presentation/widgets/home_tabs.dart';

@RoutePage()
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ActivityBloc>(
      create: (final BuildContext context) =>
      AppInjector.getIt<ActivityBloc>()..add(const ActivityInitialized()),
      child: const _ActivityScreenView(),
    );
  }
}

class _ActivityScreenView extends StatelessWidget {
  const _ActivityScreenView();

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.appColors.white,
        appBar: CustomAppBar(
          title: context.locale.activity,
          showBackButton: false,
          showDivider: false,
          actions: <Widget>[
            SvgIconButton(
              svgPath: AppAssets.leaderboardIc,
              onPressed: () {},
              iconSize: 48,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: BlocBuilder<ActivityBloc, ActivityState>(
          builder: (final BuildContext context, final ActivityState state) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: HomeTabs(
                    tabs: <String>[
                      context.locale.daily,
                      context.locale.weekly,
                      context.locale.monthly,
                    ],
                    onTabChanged: (final int index) {
                      context.read<ActivityBloc>().add(
                        ActivityTabChanged(index),
                      );
                    },
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(
                    state.selectedTabIndex.getPeriodTitle(
                      context,
                      state.currentDate,
                    ),
                    style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                      color: context.appColors.c040415,
                    ),
                  ),
                  subtitle: Text(
                    state.selectedTabIndex.getDateRangeText(
                      state.currentDate,
                      context,
                    ),
                    style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                      color: context.appColors.c686873,
                    ),
                  ),
                  trailing: Row(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SvgIconButton(
                        svgPath: AppAssets.leftIc,
                        onPressed: () {
                          context.read<ActivityBloc>().add(
                            const ActivityDateNavigated(false),
                          );
                        },
                        iconSize: 40,
                        padding: EdgeInsets.zero,
                      ),
                      SvgIconButton(
                        svgPath: AppAssets.icRight,
                        onPressed: () {
                          context.read<ActivityBloc>().add(
                            const ActivityDateNavigated(true),
                          );
                        },
                        iconSize: 40,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ColoredBox(
                    color: context.appColors.cEAECF0,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        DailyActivityView(date: state.currentDate),
                        WeeklyActivityView(
                          startDate: state.currentDate.subtract(
                            Duration(days: state.currentDate.weekday - 1),
                          ),
                          endDate: state.currentDate.add(
                            Duration(days: 7 - state.currentDate.weekday),
                          ),
                        ),
                        MonthlyActivityView(
                          month: state.currentDate.month,
                          year: state.currentDate.year,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
