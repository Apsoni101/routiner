import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/add_habit/presentation/widgets/create_habit_button.dart';
import 'package:routiner/feature/common/presentation/widgets/habit_horizontal_item_card.dart';
import 'package:routiner/feature/common/presentation/widgets/wave_bottom_sheet.dart';

class HabitBottomSheet extends StatelessWidget {
  const HabitBottomSheet({
    required this.title,
    super.key,
    this.padding,
    this.onHabitAdded,
  });

  final String title;
  final EdgeInsets? padding;
  final VoidCallback? onHabitAdded;

  @override
  Widget build(final BuildContext context) {
    return CommonWaveBottomSheet(
      padding: padding,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          CircleAvatar(radius: 8, backgroundColor: context.appColors.cEAECF0),

          const SizedBox(height: 26),

          /// Title
          Text(
            title.toUpperCase(),
            style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
              color: context.appColors.c9B9BA1,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 8),

          /// Create button
          CreateHabitButton(
            onPressed: () async {
              final bool? result = await context.router.push(
                CreateCustomHabitRoute(),
              );
              if ((result ?? false) && context.mounted) {
                context.router.pop(true);
              }
            },
          ),

          const SizedBox(height: 12),

          /// Popular habits title
          Text(
            context.locale.popularHabits.toUpperCase(),
            style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
              color: context.appColors.c9B9BA1,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 12),

          /// Horizontal habit cards
          SizedBox(
            height: MediaQuery.heightOf(context) * 0.14,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Habit.values.length,
              itemBuilder: (context, index) {
                final Habit habit = Habit.values[index];
                return HabitHorizontalItemCard(
                  habit: habit,
                  onTap: () async {
                    final bool? result = await context.router.push(
                      CreateCustomHabitRoute(selectedHabit: habit),
                    );
                    if ((result ?? false) && context.mounted) {
                      context.router.pop(true);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
