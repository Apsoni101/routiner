import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

class CreateHabitButton extends StatelessWidget {
  const CreateHabitButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: context.appColors.white,
        side: BorderSide(color: context.appColors.cEAECF0, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            context.locale.createCustomHabit,
            style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
              color: context.appColors.c040415,
            ),
          ),
          IconButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: context.appColors.white,
              side: BorderSide(color: context.appColors.cEAECF0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
