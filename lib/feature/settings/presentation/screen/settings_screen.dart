import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/controller/theme_controller.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final ThemeController themeController =
        AppInjector.getIt<ThemeController>();

    return Scaffold(
      backgroundColor: context.appColors.cEAECF0,
      appBar: CustomAppBar(title: context.locale.settings),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: <Widget>[
          _SectionTitle(title: context.locale.generalSection),
          const SizedBox(height: 8),
          _SettingsCard(
            children: <Widget>[
              _NavigationTile(
                path: AppAssets.bookmark,
                title: context.locale.general,
                onTap: () {
                  debugPrint('General tapped');
                },
              ),
              const _SettingsDivider(),

              _SwitchTile(
                path: AppAssets.bulbIc,
                title: context.locale.darkMode,
                initialValue: Theme.of(context).brightness == Brightness.dark,
                onChanged: (final bool value) {
                  themeController.toggleTheme();
                },
              ),
              const _SettingsDivider(),

              _NavigationTile(
                path: AppAssets.passwordIc,
                title: context.locale.security,
                onTap: () {
                  debugPrint('Security tapped');
                },
              ),
              const _SettingsDivider(),

              _NavigationTile(
                path: AppAssets.notificationDark,
                title: context.locale.notifications,
                onTap: () {
                  debugPrint('Notifications tapped');
                },
              ),
              const _SettingsDivider(),

              _SwitchTile(
                path: AppAssets.volumeUp,
                title: context.locale.sounds,
                initialValue: true,
                onChanged: (final bool value) {
                  debugPrint('Sounds: $value');
                },
              ),
              const _SettingsDivider(),

              _SwitchTile(
                path: AppAssets.play,
                title: context.locale.vacationMode,
                initialValue: false,
                onChanged: (final bool value) {
                  debugPrint('Vacation mode: $value');
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionTitle(title: context.locale.aboutUsSection),
          const SizedBox(height: 8),
          _SettingsCard(
            children: <Widget>[
              _NavigationTile(
                path: AppAssets.star,
                title: context.locale.rateRoutiner,
                onTap: () {
                  debugPrint('Rate Routiner tapped');
                },
              ),
              const _SettingsDivider(),

              _NavigationTile(
                path: AppAssets.share,
                title: context.locale.shareWithFriends,
                onTap: () {
                  debugPrint('Share with Friends tapped');
                },
              ),
              const _SettingsDivider(),

              _NavigationTile(
                path: AppAssets.infoSquare,
                title: context.locale.aboutUs,
                onTap: () {
                  debugPrint('About Us tapped');
                },
              ),
              const _SettingsDivider(),

              _NavigationTile(
                path: AppAssets.chatDots,
                title: context.locale.support,
                onTap: () {
                  debugPrint('Support tapped');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.path,
    required this.title,
    required this.onTap,
  });

  final String path;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      horizontalTitleGap: 6,
      leading: SvgPicture.asset(path, width: 24, height: 24),
      minVerticalPadding: 0,
      title: Text(
        title,
        style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
          color: context.appColors.c040415,
        ),
      ),
      trailing: SvgPicture.asset(AppAssets.arrowRight2, width: 24, height: 24),
      onTap: onTap,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.path,
    required this.title,
    required this.initialValue,
    required this.onChanged,
  });

  final String path;
  final String title;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(final BuildContext context) {
    final ValueNotifier<bool> notifier = ValueNotifier(initialValue);

    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (_, final bool value, final __) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          horizontalTitleGap: 8,
          minVerticalPadding: 0,
          leading: SvgPicture.asset(path, width: 24, height: 24),
          title: Text(
            title,
            style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
              color: context.appColors.c040415,
            ),
          ),
          trailing: Switch(
            value: value,
            onChanged: (final bool newValue) {
              notifier.value = newValue;
              onChanged(newValue);
            },
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            activeTrackColor: context.appColors.c3BA935,
            activeThumbColor: context.appColors.white,
            inactiveThumbColor: context.appColors.white,
            inactiveTrackColor: context.appColors.cEAECF0,
          ),

          onTap: () {
            notifier.value = !value;
            onChanged(notifier.value);
          },
        );
      },
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.appColors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(final BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
        color: context.appColors.c9B9BA1,
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(final BuildContext context) {
    return Divider(
      color: context.appColors.black.withValues(alpha: 0.08),
      indent: 10,
      endIndent: 10,
      height: 1,
    );
  }
}
