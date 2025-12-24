import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.enabledColor,
    this.disabledColor,
    this.enabledTextColor,
    this.disabledTextColor,
    super.key,
  });

  final VoidCallback onPressed;
  final bool enabled;
  final String label;

  final Color? enabledColor;
  final Color? disabledColor;

  final Color? enabledTextColor;
  final Color? disabledTextColor;

  @override
  Widget build(final BuildContext context) {
    final Color activeBgColor = enabledColor ?? context.appColors.c3843FF;

    final Color inactiveBgColor =
        disabledColor ?? context.appColors.c3843FF.withValues(alpha: 0.4);

    final Color activeTextColor = enabledTextColor ?? context.appColors.white;

    final Color inactiveTextColor =
        disabledTextColor ?? context.appColors.white.withValues(alpha: 0.5);

    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        backgroundColor: enabled ? activeBgColor : inactiveBgColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        label,
        style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
          color: enabled ? activeTextColor : inactiveTextColor,
        ),
      ),
    );
  }
}
