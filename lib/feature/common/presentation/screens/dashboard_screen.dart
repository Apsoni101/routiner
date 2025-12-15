import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/controller/add_habit_overlay_controller.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/add_habit/presentation/widgets/add_habit_overlay.dart';

import 'package:routiner/feature/common/presentation/widgets/bottom_nav_icon.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/rotating_svg_button.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AddHabitOverlayController _overlayController =
      AddHabitOverlayController();

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return AutoTabsScaffold(
      extendBody: true,
      routes: <PageRouteInfo<Object?>>[
        const HomeRoute(),
        const ExploreRoute(),
        const ActivityRoute(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (_, final TabsRouter tabsRouter) {
        return CustomBottomNavBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: <Widget>[
            BottomNavIcon(
              inactiveAsset: AppAssets.homeIc,
              activeAsset: AppAssets.activeHomeIc,
              isActive: tabsRouter.activeIndex == 0,
            ),
            BottomNavIcon(
              inactiveAsset: AppAssets.exploreIc,
              activeAsset: AppAssets.activeExploreIc,
              isActive: tabsRouter.activeIndex == 1,
            ),

            /// ➕ ADD HABIT BUTTON
            ValueListenableBuilder<bool>(
              valueListenable: _overlayController.isOpen,
              builder: (_, final bool isOpen, final __) {
                return RotatingSvgButton(
                  assetName: AppAssets.plusIc,
                  isRotated: isOpen,
                  onTap: () {
                    _overlayController.toggle(
                      context: context,
                      overlayBuilder: () => AddHabitOverlay.create(
                        context,
                        onDismiss: _overlayController.close,
                      ),
                    );
                  },
                );
              },
            ),

            BottomNavIcon(
              inactiveAsset: AppAssets.activityIc,
              activeAsset: AppAssets.activeActivityIc,
              isActive: tabsRouter.activeIndex == 2,
            ),
            BottomNavIcon(
              inactiveAsset: AppAssets.profileIc,
              activeAsset: AppAssets.activeProfileIc,
              isActive: tabsRouter.activeIndex == 3,
            ),
          ],
        );
      },
    );
  }
}
