import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

class ProfilePointsBadge extends StatelessWidget {
  const ProfilePointsBadge({required this.points, super.key});

  final String points;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.appColors.cFFF3DA,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(AppAssets.medalIc, width: 16, height: 16),
          const SizedBox(width: 4),
          Text(
            '$points ${context.locale.points}',
            style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
              color: context.appColors.cFEA800,
            ),
          ),
        ],
      ),
    );
  }
}
