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
  });

  final VoidCallback onPressed;
  final String text;
  final String assetName;
  final double verticalPadding;

  @override
  Widget build(final BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: SvgPicture.asset(assetName, width: 20, height: 20),
      label: Text(
        text,
        style: AppTextStyles.airbnbCerealW500S14.copyWith(
          color: context.appColors.c040415,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: 16,
        ),
        backgroundColor: context.appColors.white,
      ),
    );
  }
}
