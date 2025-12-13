import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavIcon extends StatelessWidget {
  const BottomNavIcon({
    required this.activeAsset, required this.inactiveAsset, required this.isActive, super.key,
    this.badgeCount,
  });

  final String activeAsset;
  final String inactiveAsset;
  final bool isActive;
  final int? badgeCount;

  @override
  Widget build(final BuildContext context) {
    return Badge(
      isLabelVisible: (badgeCount ?? 0) > 0,
      label: Text(
        badgeCount?.toString() ?? '',
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
        ),
      ),
      child: SvgPicture.asset(
        isActive ? activeAsset : inactiveAsset,
        width: 28,
        height: 28,
      ),
    );
  }
}
