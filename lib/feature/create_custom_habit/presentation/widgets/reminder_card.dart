import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/enums/repeat_interval.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/extensions/time_of_day_extension.dart';
import 'package:routiner/feature/create_custom_habit/presentation/widgets/days_picker_dialog.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    required this.frequency,
    required this.times,
    required this.selectedDays,
    required this.isAlarmEnabled,
    required this.selectedTime,
    super.key,
    this.onTimesChanged,
    this.onFrequencyChanged,
    this.onDaysChanged,
    this.onAlarmToggled,
    this.onTimeChanged,
  });

  final RepeatInterval frequency;
  final int times;
  final List<Day> selectedDays;
  final bool isAlarmEnabled;
  final TimeOfDay selectedTime;

  final ValueChanged<int>? onTimesChanged;
  final ValueChanged<RepeatInterval>? onFrequencyChanged;
  final ValueChanged<List<Day>>? onDaysChanged;
  final ValueChanged<bool>? onAlarmToggled;
  final ValueChanged<TimeOfDay>? onTimeChanged;

  /// -------------------- dialogs --------------------

  Future<void> _showDaysPickerDialog(final BuildContext context) async {
    final List<Day>? result = await showDialog<List<Day>>(
      context: context,
      builder: (_) => DaysPickerDialog(currentSelectedDays: selectedDays),
    );

    if (result != null) {
      onDaysChanged?.call(result);
    }
  }

  Future<void> _showTimePickerDialog(final BuildContext context) async {
    if (!isAlarmEnabled) {
      // Optionally show a snackbar or message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable alarm first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (final BuildContext context, final Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: context.appColors.c3843FF),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      onTimeChanged?.call(result);
    }
  }

  /// -------------------- display text --------------------

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

  /// -------------------- UI --------------------

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
              context.locale.reminderWorkoutMessage,
              style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                color: context.appColors.c9B9BA1,
              ),
            ),
            trailing: Switch(
              value: isAlarmEnabled,
              onChanged: onAlarmToggled,
              activeThumbColor: context.appColors.c3BA935,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: Opacity(
                  opacity: isAlarmEnabled ? 1.0 : 0.5,
                  child: TextButton.icon(
                    onPressed: isAlarmEnabled
                        ? () => _showTimePickerDialog(context)
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: context.appColors.cF3F4F6,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    icon: SvgPicture.asset(
                      AppAssets.timeIc,
                      width: 28,
                      height: 28,
                    ),
                    label: Text(
                      selectedTime.toDisplayText(),
                      style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                        color: context.appColors.c040415,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Opacity(
                  opacity: isAlarmEnabled ? 1.0 : 0.5,
                  child: TextButton.icon(
                    onPressed: isAlarmEnabled
                        ? () => _showDaysPickerDialog(context)
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: context.appColors.cF3F4F6,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
