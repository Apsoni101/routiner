import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';
import 'package:routiner/feature/home/presentation/widgets/clubs_tab_view.dart';
import 'package:routiner/feature/home/presentation/widgets/home_tabs.dart';
import 'package:routiner/feature/profile/presentation/widgets/achievements_tab_view.dart';
import 'package:routiner/feature/profile/presentation/widgets/activity_tab_view.dart';
import 'package:routiner/feature/profile/presentation/widgets/friends_tab_view.dart';
import 'package:routiner/feature/profile/presentation/widgets/profile_header.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.appColors.white,
        appBar: CustomAppBar(
          title: context.locale.profile,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SvgIconButton(
                padding: EdgeInsets.zero,
                svgPath: AppAssets.settingsIc,
                onPressed: () {},
                iconSize: 48,
              ),
            ),
          ],
          showBackButton: false,
          showDivider: false,
        ),
        body: Column(
          children: [
            const ProfileHeader(
              name: 'Mert Kahveci',
              subtitle: '1452',
              imagePath: AppAssets.avatar1Png,
            ),

            Container(
              color: context.appColors.white,
              padding: const EdgeInsetsGeometry.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: HomeTabs(
                tabs: <String>[
                  context.locale.activity,
                  context.locale.friends,
                  context.locale.achievements,
                ],
                onTabChanged: (int) {},
              ),

            ),
            Expanded(
              child: ColoredBox(
                color: context.appColors.cEAECF0,
                child: const TabBarView(
                  children: <Widget>[
                     ActivityTabView(),
                     FriendsTabView(),
                     AchievementsTabView(),
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
