import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

class NextButton extends StatelessWidget {
  const NextButton({required this.onPressed, this.enabled = true, super.key});

  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(final BuildContext context) {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        backgroundColor: enabled
            ? context.appColors.c3843FF
            : context.appColors.c3843FF.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        context.locale.next,
        style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
          color: context.appColors.white.withOpacity(enabled ? 1 : 0.5),
        ),
      ),
    );
  }
}
