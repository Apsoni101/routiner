import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    required this.onPressed,
    required this.text,
    required this.assetName,
    super.key,
    this.verticalPadding = 8,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String text;
  final String assetName;
  final double verticalPadding;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    return TextButton.icon(
      onPressed: isDisabled ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.appColors.c040415.withValues(alpha: 0.5),
                ),
              ),
            )
          : SvgPicture.asset(assetName, width: 20, height: 20),
      label: Text(
        text,
        style: AppTextStyles.airbnbCerealW500S14.copyWith(
          color: isDisabled
              ? context.appColors.c040415.withValues(alpha: 0.5)
              : context.appColors.c040415,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: 16,
        ),
        backgroundColor: isDisabled
            ? context.appColors.white.withValues(alpha: 0.7)
            : context.appColors.white,
      ),
    );
  }
}
