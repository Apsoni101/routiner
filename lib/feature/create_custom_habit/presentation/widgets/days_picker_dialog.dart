import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/enums/days.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

class DaysPickerDialog extends StatelessWidget {
  const DaysPickerDialog({required this.currentSelectedDays, super.key});

  final List<Day> currentSelectedDays;

  @override
  Widget build(final BuildContext context) {
    return _DaysPickerContent(initialSelectedDays: currentSelectedDays);
  }
}

class _DaysPickerContent extends StatefulWidget {
  const _DaysPickerContent({required this.initialSelectedDays});

  final List<Day> initialSelectedDays;

  @override
  State<_DaysPickerContent> createState() => _DaysPickerContentState();
}

class _DaysPickerContentState extends State<_DaysPickerContent> {
  late List<Day> selectedDays;

  final List<Day> allDays = const <Day>[
    Day.sunday,
    Day.monday,
    Day.tuesday,
    Day.wednesday,
    Day.thursday,
    Day.friday,
    Day.saturday,
  ];

  @override
  void initState() {
    super.initState();
    selectedDays = List<Day>.from(widget.initialSelectedDays);
  }

  void _toggleDay(final Day day) {
    setState(() {
      if (day == Day.everyday) {
        selectedDays = selectedDays.contains(Day.everyday)
            ? <Day>[]
            : <Day>[Day.everyday];
        return;
      }

      selectedDays.remove(Day.everyday);

      selectedDays.contains(day)
          ? selectedDays.remove(day)
          : selectedDays.add(day);

      if (selectedDays.length == allDays.length) {
        selectedDays = <Day>[Day.everyday];
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              context.locale.selectDays,
              style: AppTextStyles.airbnbCerealW500S14Lh20.copyWith(
                color: context.appColors.c040415,
              ),
            ),
            const SizedBox(height: 24),

            _buildDayTile(
              context,
              Day.everyday,
              selectedDays.contains(Day.everyday),
            ),

            const Divider(),

            ...allDays.map(
              (final Day day) => _buildDayTile(
                context,
                day,
                selectedDays.contains(day) &&
                    !selectedDays.contains(Day.everyday),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    context.locale.cancel,
                    style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                      color: context.appColors.c686873,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: selectedDays.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(selectedDays),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColors.c3843FF,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    context.locale.confirm,
                    style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                      color: context.appColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTile(
    final BuildContext context,
    final Day day,
    final bool isSelected,
  ) {
    return ListTile(
      title: Text(
        day.label(context),
        style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
          color: isSelected
              ? context.appColors.c3843FF
              : context.appColors.c040415,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: context.appColors.c3843FF)
          : Icon(Icons.circle_outlined, color: context.appColors.c9B9BA1),
      onTap: () => _toggleDay(day),
    );
  }
}
