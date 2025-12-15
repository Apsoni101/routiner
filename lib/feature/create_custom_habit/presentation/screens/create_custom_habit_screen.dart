import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/add_habit/presentation/widgets/create_custom_habit_text.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_button.dart';
import 'package:routiner/feature/common/presentation/widgets/tile_button.dart';
import 'package:routiner/feature/profile/presentation/widgets/profile_textfield.dart';

@RoutePage()
class CreateCustomHabitScreen extends StatelessWidget {
  const CreateCustomHabitScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.locale.createCustomHabit),
      backgroundColor: context.appColors.cF6F9FF,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: CustomButton(label: context.locale.addHabit, onPressed: () {}),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          CreateCustomHabitText(text: context.locale.name.toUpperCase()),
          ProfileTextField(controller: TextEditingController()),
          const SizedBox(height: 16),
          CreateCustomHabitText(
            text: context.locale.iconAndColor.toUpperCase(),
          ),
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: TileButton(
                  title: context.locale.walking,
                  subtitle: context.locale.icon,
                  leading: Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.appColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: AlignmentDirectional.topStart,
                    child: Image.asset(Habit.values.first.path),
                  ),
                  onTap: () {},
                ),
              ),
              Expanded(
                child: TileButton(
                  title: context.locale.orange,
                  subtitle: context.locale.color,
                  leading: Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.appColors.c3BA935,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: AlignmentDirectional.topStart,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CreateCustomHabitText(text: context.locale.goal.toUpperCase()),
          const SizedBox(height: 16),
          CreateCustomHabitText(text: context.locale.reminders.toUpperCase()),
          const SizedBox(height: 16),
          CreateCustomHabitText(text: context.locale.type.toUpperCase()),
          const SizedBox(height: 16),
          CreateCustomHabitText(text: context.locale.location.toUpperCase()),
        ],
      ),
    );
  }
}
