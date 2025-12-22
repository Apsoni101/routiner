import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/controller/month_date_selector_controller.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/time_of_day_extension.dart';

class MonthDateSelector extends StatefulWidget {
  const MonthDateSelector({super.key, this.onDateSelected});

  /// Callback for selected date
  final ValueChanged<DateTime>? onDateSelected;

  @override
  State<MonthDateSelector> createState() => _MonthDateSelectorState();
}

class _MonthDateSelectorState extends State<MonthDateSelector> {
  late final List<DateTime> dates;
  late final MonthDateSelectorController controller;

  @override
  void initState() {
    super.initState();

    dates = DateTime.now().daysOfMonth;

    final DateTime today = DateTime.now();
    final int initialIndex = dates.indexWhere(
          (final DateTime d) =>
      d.year == today.year && d.month == today.month && d.day == today.day,
    );

    controller = MonthDateSelectorController(initialIndex: initialIndex);

    controller.selectedIndexNotifier.addListener(() {
      final int index = controller.selectedIndexNotifier.value;
      if (widget.onDateSelected != null && index >= 0 && index < dates.length) {
        widget.onDateSelected!(dates[index]);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      const double itemWidth = 48 + 6;
      final double offset = initialIndex * itemWidth;
      controller.scrollController.jumpTo(
        offset.clamp(
          controller.scrollController.position.minScrollExtent,
          controller.scrollController.position.maxScrollExtent,
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _isFuture(final DateTime date) {
    final DateTime today = DateTime.now();
    return date.isAfter(DateTime(today.year, today.month, today.day));
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ValueListenableBuilder<int>(
        valueListenable: controller.selectedIndexNotifier,
        builder: (final BuildContext context, final int selectedIndex, _) {
          return ListView.separated(
            controller: controller.scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (final BuildContext context, final int index) {
              final DateTime date = dates[index];
              final bool isDisabled = _isFuture(date);

              return DateItem(
                date: date,
                isSelected: selectedIndex == index,
                isDisabled: isDisabled,
                onTap: isDisabled ? null : () => controller.selectDate(index),
              );
            },
            separatorBuilder: (_, final __) => const SizedBox(width: 8),
          );
        },
      ),
    );
  }
}

class DateItem extends StatelessWidget {
  const DateItem({
    required this.date,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
    super.key,
  });

  final DateTime date;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final Color borderColor = isSelected
        ? context.appColors.c6B73FF
        : context.appColors.cCDCDD0;

    return AspectRatio(
      aspectRatio: 0.74,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          backgroundColor: context.appColors.white,
          side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${date.day}',
              style: AppTextStyles.airbnbCerealW500S20Lh24Ls0.copyWith(
                color: isSelected
                    ? context.appColors.c6B73FF
                    : context.appColors.c040415,
              ),
            ),
            Text(
              date.shortWeekday(context),
              style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
                color: isSelected
                    ? context.appColors.c6B73FF
                    : context.appColors.cCDCDD0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
