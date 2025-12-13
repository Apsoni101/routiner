import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class SelectableGridItem extends StatelessWidget {
  const SelectableGridItem({
    required this.label,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final Color borderColor = isSelected
        ? context.appColors.c3843FF
        : context.appColors.cEAECF0;

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: context.appColors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(iconPath, width: 48, height: 48),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
              color: context.appColors.c040415,
            ),
          ),
        ],
      ),
    );
  }
}
