import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

class CompleteButton extends StatelessWidget {
  const CompleteButton({
    required this.onPressed,
    this.enabled = true,
    super.key,
    this.backgroundColor,
    this.textColor,
  });

  final VoidCallback onPressed;
  final bool enabled;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(final BuildContext context) {
    final Color bg = backgroundColor ?? context.appColors.red;
    final Color txtColor = textColor ?? context.appColors.lightSilver;

    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      // disable when false
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? bg : bg.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
      icon: Icon(
        Icons.check,
        color: enabled ? txtColor : txtColor.withValues(alpha: 0.4),
        size: 24,
      ),
      iconAlignment: IconAlignment.end,
      label: Text(
        context.locale.complete,
        style: AppTextStyles.hintTxtStyle.copyWith(
          color: enabled ? txtColor : txtColor.withValues(alpha: 0.4),
          fontSize: 16,
        ),
      ),
    );
  }
}
