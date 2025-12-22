import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_colors.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/create_custom_habit/presentation/bloc/icon_picker_bloc/icon_picker_bloc.dart';

class IconPickerDialog extends StatelessWidget {
  const IconPickerDialog({super.key, this.selectedIcon, this.selectedHabit});

  final IconData? selectedIcon;
  final Habit? selectedHabit;

  static final List<IconData> _habitIcons = <IconData>[
    Icons.fitness_center,
    Icons.book,
    Icons.bedtime,
    Icons.water_drop,
    Icons.restaurant,
    Icons.directions_run,
    Icons.self_improvement,
    Icons.lightbulb,
    Icons.brush,
    Icons.music_note,
    Icons.movie,
    Icons.shopping_bag,
    Icons.work,
    Icons.school,
    Icons.favorite,
    Icons.healing,
    Icons.local_drink,
    Icons.smoke_free,
    Icons.cleaning_services,
    Icons.local_laundry_service,
    Icons.checkroom,
    Icons.outdoor_grill,
    Icons.pets,
    Icons.yard,
    Icons.forest,
    Icons.wb_sunny,
    Icons.nightlight,
    Icons.beach_access,
    Icons.pool,
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_tennis,
    Icons.videogame_asset,
    Icons.computer,
    Icons.phone_android,
    Icons.tablet,
    Icons.tv,
    Icons.radio,
    Icons.camera_alt,
    Icons.photo_camera,
    Icons.palette,
    Icons.create,
    Icons.edit,
    Icons.mic,
    Icons.headphones,
    Icons.speaker,
    Icons.theaters,
    Icons.local_pizza,
    Icons.local_cafe,
    Icons.cake,
    Icons.emoji_food_beverage,
    Icons.fastfood,
    Icons.restaurant_menu,
    Icons.local_bar,
    Icons.local_hospital,
    Icons.medical_services,
    Icons.medication,
    Icons.psychology,
    Icons.mood,
    Icons.sentiment_satisfied,
    Icons.star,
    Icons.grade,
    Icons.emoji_events,
    Icons.celebration,
    Icons.card_giftcard,
    Icons.spa,
    Icons.hot_tub,
    Icons.bathtub,
    Icons.shower,
  ];

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<IconPickerBloc>(
      create: (_) => IconPickerBloc(
        selectedIcon: selectedIcon,
        selectedHabit: selectedHabit,
      ),
      child: const _IconPickerDialogContent(),
    );
  }
}

class _IconPickerDialogContent extends StatelessWidget {
  const _IconPickerDialogContent();

  void _confirm(final BuildContext context, final IconPickerState state) {
    if (state.selectedHabit != null) {
      context.router.pop(<String, Habit?>{'habit': state.selectedHabit});
    } else if (state.selectedIcon != null) {
      context.router.pop(<String, IconData?>{'icon': state.selectedIcon});
    }
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<IconPickerBloc, IconPickerState>(
      builder: (final BuildContext context, final IconPickerState state) {
        return DefaultTabController(
          length: 2,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 550),
              child: Column(
                children: <Widget>[
                  Text(
                    context.locale.selectIconTitle,
                    style: AppTextStyles.airbnbCerealW500S18Lh24Ls0,
                  ),

                  const SizedBox(height: 8),

                  TabBar(
                    indicatorColor: context.appColors.c3843FF,
                    labelColor: context.appColors.c3843FF,
                    unselectedLabelColor: context.appColors.c686873,
                    tabs: <Tab>[
                      Tab(text: context.locale.tabPreset),
                      Tab(text: context.locale.tabIcons),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        _PresetHabitsTab(selectedHabit: state.selectedHabit),
                        _MaterialIconsTab(selectedIcon: state.selectedIcon),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.canConfirm
                          ? () => _confirm(context, state)
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(context.locale.selectButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PresetHabitsTab extends StatelessWidget {
  const _PresetHabitsTab({required this.selectedHabit});

  final Habit? selectedHabit;

  @override
  Widget build(final BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: Habit.values.length,
      itemBuilder: (final BuildContext context, final int index) {
        final Habit habit = Habit.values[index];
        final bool isSelected = selectedHabit == habit;

        return IconButton(
          onPressed: () {
            context.read<IconPickerBloc>().add(HabitSelected(habit));
          },
          style: IconButton.styleFrom(
            fixedSize: const Size(64, 64),
            backgroundColor: isSelected ? colors.cF6F9FF : colors.cF3F4F6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? colors.c3843FF : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          icon: Column(
            spacing: 2,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(habit.path, width: 28, height: 28),
              Text(
                habit.label,
                style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MaterialIconsTab extends StatelessWidget {
  const _MaterialIconsTab({required this.selectedIcon});

  final IconData? selectedIcon;

  @override
  Widget build(final BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: IconPickerDialog._habitIcons.length,
      itemBuilder: (final BuildContext context, final int index) {
        final IconData icon = IconPickerDialog._habitIcons[index];
        final bool isSelected = selectedIcon == icon;

        return IconButton(
          onPressed: () {
            context.read<IconPickerBloc>().add(IconSelected(icon));
          },
          icon: Icon(icon),
          style: IconButton.styleFrom(
            fixedSize: const Size(48, 48),
            backgroundColor: isSelected ? colors.cF6F9FF : colors.cF3F4F6,
            foregroundColor: isSelected ? colors.c3843FF : colors.c686873,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? colors.c3843FF : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
