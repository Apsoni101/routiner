import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class SignupLoginButton extends StatelessWidget {
  const SignupLoginButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.backgroundColor,
    this.textColor,
  });

  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final String text;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      alignment: Alignment.centerLeft,
      backgroundColor: backgroundColor ?? Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: AppTextStyles.hintTxtStyle.copyWith(
            color: context.appColors.white,
            fontSize: 16,
          ),
        ),
        SvgPicture.asset(AppAssets.navArrowRightIc),
      ],
    ),
  );
}
