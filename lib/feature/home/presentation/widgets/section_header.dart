import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.actionText,
    required this.onActionPressed,
    super.key,
  });

  final String title;
  final String actionText;
  final VoidCallback onActionPressed;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyles.airbnbCerealW500S14Lh20.copyWith(
              color: context.appColors.c040415,
            ),
          ),
          TextButton(
            onPressed: onActionPressed,
            child: Text(
              actionText,
              style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
                color: context.appColors.c3843FF,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
