import 'package:flutter/material.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/tile_button.dart';

class IconColorRow extends StatelessWidget {
  const IconColorRow({
    required this.onIconTap,
    required this.onColorTap,
    required this.selectedColor,
    this.selectedIcon,
    this.selectedHabit,
    this.selectedIconName,
    super.key,
  }) : assert(
         selectedIcon != null || selectedHabit != null,
         'Either selectedIcon or selectedHabit must be provided',
       );

  final VoidCallback onIconTap;
  final VoidCallback onColorTap;
  final IconData? selectedIcon;
  final Habit? selectedHabit;
  final Color selectedColor;
  final String? selectedIconName;

  // ---------------- COLOR NAME ----------------
  String _getColorName(final BuildContext context, final Color color) {
    final Map<MaterialColor, String> colorMap = <MaterialColor, String>{
      Colors.red: context.locale.colorRed,
      Colors.pink: context.locale.colorPink,
      Colors.purple: context.locale.colorPurple,
      Colors.deepPurple: context.locale.colorDeepPurple,
      Colors.indigo: context.locale.colorIndigo,
      Colors.blue: context.locale.colorBlue,
      Colors.lightBlue: context.locale.colorLightBlue,
      Colors.green: context.locale.colorGreen,
      Colors.yellow: context.locale.colorYellow,
      Colors.orange: context.locale.colorOrange,
      Colors.grey: context.locale.colorGrey,
      Colors.blueGrey: context.locale.colorBlueGrey,
    };

    for (final MapEntry<MaterialColor, String> entry in colorMap.entries) {
      if (entry.key.toARGB32() == color.toARGB32()) {
        return entry.value;
      }
    }

    // fallback → hex color
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  // ---------------- ICON NAME ----------------
  String _getIconName(
    final BuildContext context,
    final IconData? icon,
    final Habit? habit,
  ) {
    if (habit != null) {
      return habit.label;
    }

    final Map<IconData, String> iconMap = <IconData, String>{
      Icons.fitness_center: context.locale.iconFitness,
      Icons.book: context.locale.iconReading,
      Icons.bedtime: context.locale.iconSleep,
      Icons.water_drop: context.locale.iconWater,
      Icons.restaurant: context.locale.iconFood,
      Icons.directions_run: context.locale.iconRunning,
      Icons.self_improvement: context.locale.iconMeditation,
      Icons.lightbulb: context.locale.iconIdeas,
      Icons.palette: context.locale.iconArt,
      Icons.music_note: context.locale.iconMusic,
      Icons.movie: context.locale.iconMovies,
      Icons.shopping_bag: context.locale.iconShopping,
      Icons.work: context.locale.iconWork,
      Icons.school: context.locale.iconStudy,
      Icons.favorite: context.locale.iconFavorite,
      Icons.healing: context.locale.iconHealth,
      Icons.local_drink: context.locale.iconDrink,
      Icons.smoke_free: context.locale.iconNoSmoking,
      Icons.cleaning_services: context.locale.iconCleaning,
      Icons.pets: context.locale.iconPets,
      Icons.yard: context.locale.iconGarden,
      Icons.wb_sunny: context.locale.iconSunny,
      Icons.nightlight: context.locale.iconNight,
      Icons.beach_access: context.locale.iconBeach,
      Icons.pool: context.locale.iconSwimming,
      Icons.sports_soccer: context.locale.iconSoccer,
      Icons.sports_basketball: context.locale.iconBasketball,
      Icons.videogame_asset: context.locale.iconGaming,
      Icons.computer: context.locale.iconComputer,
      Icons.camera_alt: context.locale.iconPhotography,
      Icons.create: context.locale.iconWriting,
      Icons.mic: context.locale.iconRecording,
      Icons.headphones: context.locale.iconListening,
      Icons.local_pizza: context.locale.iconPizza,
      Icons.local_cafe: context.locale.iconCoffee,
      Icons.cake: context.locale.iconDessert,
      Icons.fastfood: context.locale.iconFastFood,
      Icons.local_hospital: context.locale.iconHospital,
      Icons.medical_services: context.locale.iconMedical,
      Icons.medication: context.locale.iconMedicine,
      Icons.psychology: context.locale.iconMentalHealth,
      Icons.mood: context.locale.iconMood,
      Icons.star: context.locale.iconStar,
      Icons.grade: context.locale.iconAchievement,
      Icons.emoji_events: context.locale.iconTrophy,
      Icons.celebration: context.locale.iconCelebration,
      Icons.spa: context.locale.iconSpa,
      Icons.hot_tub: context.locale.iconHotTub,
      Icons.bathtub: context.locale.iconBath,
      Icons.shower: context.locale.iconShower,
    };

    return iconMap[icon] ?? selectedIconName ?? context.locale.iconDefault;
  }

  // ---------------- ICON WIDGET ----------------
  Widget _buildIconWidget() {
    if (selectedHabit != null) {
      return Image.asset(selectedHabit!.path, width: 24, height: 24);
    }

    if (selectedIcon != null) {
      return Icon(selectedIcon, size: 24, color: selectedColor);
    }

    return const SizedBox.shrink();
  }

  // ---------------- UI ----------------
  @override
  Widget build(final BuildContext context) {
    return Row(
      spacing: 8,
      children: <Widget>[
        Expanded(
          child: TileButton(
            title: _getIconName(context, selectedIcon, selectedHabit),
            subtitle: context.locale.icon,
            leading: Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: context.appColors.cF3F4F6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildIconWidget(),
            ),
            onTap: onIconTap,
          ),
        ),
        Expanded(
          child: TileButton(
            title: _getColorName(context, selectedColor),
            subtitle: context.locale.color,
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            onTap: onColorTap,
          ),
        ),
      ],
    );
  }
}
