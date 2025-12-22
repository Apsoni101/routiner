import 'package:flutter/material.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.onCalendarTap,
    required this.onNotificationTap,
    required this.showNotificationBadge,
    super.key,
  });

  final VoidCallback onCalendarTap;
  final VoidCallback onNotificationTap;
  final bool showNotificationBadge;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SvgIconButton(
        svgPath: AppAssets.calendarIc,
        onPressed: onCalendarTap,
        borderRadius: 16,
        padding: const EdgeInsets.all(12),
        borderColor: context.appColors.cEAECF0,
      ),
      trailing: showNotificationBadge
          ? Badge(
              backgroundColor: Colors.red,
              smallSize: 8,
              child: _NotificationButton(onTap: onNotificationTap),
            )
          : _NotificationButton(onTap: onNotificationTap),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return SvgIconButton(
      svgPath: AppAssets.notificationIc,
      onPressed: onTap,
      borderRadius: 16,
      padding: const EdgeInsets.all(12),
      borderColor: context.appColors.cEAECF0,
    );
  }
}
