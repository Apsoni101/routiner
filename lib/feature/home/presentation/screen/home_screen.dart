import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/home/presentation/bloc/home_bloc.dart';
import 'package:routiner/feature/home/presentation/widgets/clubs_tab_view.dart';
import 'package:routiner/feature/home/presentation/widgets/home_greeting.dart';
import 'package:routiner/feature/home/presentation/widgets/home_header.dart';
import 'package:routiner/feature/home/presentation/widgets/home_tabs.dart';
import 'package:routiner/feature/home/presentation/widgets/today_tab_view.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onHabitChanged, this.initialTab = 0});

  final void Function(VoidCallback)? onHabitChanged;
  final int initialTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void didUpdateWidget(final HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _tabController.index = widget.initialTab;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => AppInjector.getIt<HomeBloc>()..add(const LoadHomeData()),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(elevation: 0),
        ),
        backgroundColor: context.appColors.white,
        body: Column(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: <Widget>[
                HomeHeader(
                  showNotificationBadge: true,
                  onCalendarTap: () {
                    debugPrint('Calendar tapped');
                  },
                  onNotificationTap: () {
                    debugPrint('Notification tapped');
                  },
                ),
                const HomeGreeting(),
                const SizedBox(height: 10),
                HomeTabs(
                  tabs: <String>[context.locale.today, context.locale.clubs],
                  controller: _tabController,
                  onTabChanged: (final int index) {
                    debugPrint('Tab changed to $index');
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
            Expanded(
              child: ColoredBox(
                color: context.appColors.cEAECF0,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    TodayTabView(onHabitChanged: widget.onHabitChanged),
                    const ClubsTabView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
