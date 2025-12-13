import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.zero,
    ),
    child: Text(
      textAlign: TextAlign.start,
      context.locale.forgotPassword,
      style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
        color: context.appColors.c686873,
      ),
    ),
  );
}
