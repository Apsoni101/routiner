// selectable_grid_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class SelectableGridItem extends StatelessWidget {
  final String label;
  final String? iconPath;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableGridItem({
    required this.label,
    this.iconPath,
    this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? context.appColors.c3843FF
                : context.appColors.cEAECF0,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath!,
                width: 48,
                height: 48,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? context.appColors.c3843FF
                      : context.appColors.cEAECF0,
                  BlendMode.srcIn,
                ),
              )
            else if (icon != null)
              Icon(
                icon,
                size: 48,
                color: isSelected
                    ? context.appColors.c3843FF
                    : context.appColors.cEAECF0,
              ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                color: isSelected
                    ? context.appColors.c040415
                    : context.appColors.c686873,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
