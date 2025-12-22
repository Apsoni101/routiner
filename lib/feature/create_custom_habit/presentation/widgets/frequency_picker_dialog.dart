import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

class FrequencyPickerDialog extends StatelessWidget {
  const FrequencyPickerDialog({required this.currentFrequency, super.key});

  final RepeatInterval currentFrequency;

  @override
  Widget build(final BuildContext context) {
    const List<RepeatInterval> frequencies = RepeatInterval.values;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          Text(
            context.locale.selectFrequency,
            style: AppTextStyles.airbnbCerealW500S14Lh20.copyWith(
              color: context.appColors.c040415,
            ),
          ),
          const SizedBox(height: 24),

          ...frequencies.map((final RepeatInterval repeatInterval) {
            final bool isSelected = repeatInterval == currentFrequency;

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                repeatInterval.label(context),
                style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                  color: isSelected
                      ? context.appColors.c3843FF
                      : context.appColors.c040415,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_circle, color: context.appColors.c3843FF)
                  : null,
              onTap: () {
                context.router.pop(repeatInterval);
              },
            );
          }),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () => context.router.pop(),
                child: Text(
                  context.locale.cancel,
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: context.appColors.c686873,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
