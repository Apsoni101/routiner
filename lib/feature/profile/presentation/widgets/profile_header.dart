import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/profile_points_badge.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.name,
    required this.subtitle,
    required this.imagePath,
    super.key,
  });

  final String name;
  final String subtitle;
  final String imagePath;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 28,
            child: Image.asset(imagePath, fit: BoxFit.fill),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
                  color: context.appColors.c040415,
                ),
              ),
              const SizedBox(height: 4),
              ProfilePointsBadge(points: subtitle),
            ],
          ),
        ],
      ),
    );
  }
}
