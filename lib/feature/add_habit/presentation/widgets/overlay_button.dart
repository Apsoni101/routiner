import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class OverlayButton extends StatelessWidget {
  const OverlayButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String subtitle;
  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.appColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 8,
        minVerticalPadding: 0,
        visualDensity: VisualDensity.compact,
        title: Text(
          title,
          style: AppTextStyles.airbnbCerealW500S14Lh20.copyWith(
            color: context.appColors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
            color: context.appColors.slate,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SvgPicture.asset(icon, width: 36, height: 36),
      ),
    );
  }
}
