import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/extensions/color_extension.dart';

/// ---------------------------------------------------------------------------
/// Habit Card
/// ---------------------------------------------------------------------------
class HabitHorizontalItemCard extends StatelessWidget {
  const HabitHorizontalItemCard({
    required this.habit,
    required this.onTap,
    super.key,
  });

  final Habit habit;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1.25,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: habit.color(context.appColors).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Habit name
              Container(
                width: 36,
                height: 36,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.appColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: AlignmentDirectional.topStart,
                child: Image.asset(habit.path),
              ),
              const SizedBox(height: 8),
              Text(
                habit.label,
                textAlign: TextAlign.start,
                style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                  color: context.appColors.c040415,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${habit.goalValue} ${habit.goalUnit.label(context)}',
                textAlign: TextAlign.start,
                style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                  color: context.appColors.c686873,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
