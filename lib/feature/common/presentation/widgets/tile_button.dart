import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class TileButton extends StatelessWidget {
  const TileButton({
    required this.title,
    this.subtitle,
    this.leading,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: context.appColors.white,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: leading,
      title: Text(
        title,
        style: AppTextStyles.airbnbCerealW500S14Lh20.copyWith(
          color: context.appColors.c040415,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                color: context.appColors.c9B9BA1,
              ),
            ),
    );
  }
}
