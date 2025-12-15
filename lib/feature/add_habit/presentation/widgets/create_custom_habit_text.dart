import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';

class CreateCustomHabitText extends StatelessWidget {
  const CreateCustomHabitText({super.key, required this.text});

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
        color: context.appColors.c040415,
      ),
    );
  }
}
