import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/goal_unit.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/goal_value.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/days_picker_dialog.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/frequency_picker_dialog.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/goal_picker_dialog.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    required this.frequency,
    required this.goalValue,
    required this.goalUnit,
    required this.selectedDays,
    this.onGoalChanged,
    this.onFrequencyChanged,
    this.onDaysChanged,
    super.key,
  });

  final RepeatInterval frequency;
  final int goalValue;
  final GoalUnit goalUnit;
  final List<Day> selectedDays;

  final ValueChanged<GoalValue>? onGoalChanged;
  final ValueChanged<RepeatInterval>? onFrequencyChanged;
  final ValueChanged<List<Day>>? onDaysChanged;

  Future<void> _showGoalPickerDialog(final BuildContext context) async {
    final GoalValue? result = await showDialog<GoalValue>(
      context: context,
      builder: (_) =>
          GoalPickerDialog(currentValue: goalValue, currentUnit: goalUnit),
    );

    if (result != null) {
      onGoalChanged?.call(result);
    }
  }

  Future<void> _showFrequencyPickerDialog(final BuildContext context) async {
    final RepeatInterval? selectedFrequency = await showDialog<RepeatInterval>(
      context: context,
      builder: (_) => FrequencyPickerDialog(currentFrequency: frequency),
    );

    if (selectedFrequency != null) {
      onFrequencyChanged?.call(selectedFrequency);
    }
  }

  Future<void> _showDaysPickerDialog(final BuildContext context) async {
    final List<Day>? result = await showDialog<List<Day>>(
      context: context,
      builder: (_) => DaysPickerDialog(currentSelectedDays: selectedDays),
    );

    if (result != null) {
      onDaysChanged?.call(result);
    }
  }

  String _getDaysDisplayText(final BuildContext context) {
    if (selectedDays.isEmpty) {
      return context.locale.selectDays;
    }

    if (selectedDays.contains(Day.everyday)) {
      return Day.everyday.label(context);
    }

    if (selectedDays.length == 1) {
      return selectedDays.first.label(context);
    }

    return '${selectedDays.length} ${context.locale.days}';
  }

  String _getGoalSubtitle(BuildContext context) {
    switch (goalUnit) {
      case GoalUnit.times:
      case GoalUnit.sessions:
      case GoalUnit.repetitions:
      case GoalUnit.items:
        return context.locale.orMorePerDay;

      case GoalUnit.ml:
      case GoalUnit.glasses:
        return context.locale.drinkGoalPerDay;

      case GoalUnit.steps:
      case GoalUnit.meters:
      case GoalUnit.kilometers:
        return context.locale.walkingGoalPerDay;

      case GoalUnit.minutes:
      case GoalUnit.hours:
      case GoalUnit.seconds:
        return context.locale.durationGoalPerDay;

      case GoalUnit.pages:
      case GoalUnit.words:
      case GoalUnit.chapters:
        return context.locale.readingGoalPerDay;

      case GoalUnit.calories:
        return context.locale.calorieGoalPerDay;
    }
  }


  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              '$goalValue ${goalUnit.label(context)}',
              style: AppTextStyles.airbnbCerealW500S14Lh20.copyWith(
                color: context.appColors.c040415,
              ),
            ),
            subtitle: Text(
              _getGoalSubtitle(context),
              style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                color: context.appColors.c9B9BA1,
              ),
            ),
            trailing: IconButton(
              onPressed: () => _showGoalPickerDialog(context),
              icon: SvgPicture.asset(AppAssets.editIc, width: 36, height: 36),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _showFrequencyPickerDialog(context),
                  style: TextButton.styleFrom(
                    backgroundColor: context.appColors.cF3F4F6,
                  ),
                  icon: SvgPicture.asset(
                    AppAssets.repeatIc,
                    width: 28,
                    height: 28,
                  ),
                  label: Text(
                    frequency.label(context),
                    style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                      color: context.appColors.c040415,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _showDaysPickerDialog(context),
                  style: TextButton.styleFrom(
                    backgroundColor: context.appColors.cF3F4F6,
                  ),
                  icon: SvgPicture.asset(
                    AppAssets.dayIc,
                    width: 28,
                    height: 28,
                  ),
                  label: Text(
                    _getDaysDisplayText(context),
                    style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                      color: context.appColors.c040415,
                    ),
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
