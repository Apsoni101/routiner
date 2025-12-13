import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/common/presentation/widgets/bottom_nav_icon.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/rotating_svg_button.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
            RotatingSvgButton(assetName: AppAssets.plusIc, onTap: () {}),
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
