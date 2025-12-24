import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/localisation/app_localizations.dart';

extension DateFormatting on DateTime {
  /// Formats date as "Jan 15"
  String toShortDateString(final BuildContext context) {
    final List<String> months = <String>[
      context.locale.jan,
      context.locale.feb,
      context.locale.mar,
      context.locale.apr,
      context.locale.may,
      context.locale.jun,
      context.locale.jul,
      context.locale.aug,
      context.locale.sep,
      context.locale.oct,
      context.locale.nov,
      context.locale.dec,
    ];
    return '${months[month - 1]} $day';
  }

  /// Formats date as "January 2024"
  String toMonthYearString(final BuildContext context) {
    final List<String> months = <String>[
      context.locale.january,
      context.locale.february,
      context.locale.march,
      context.locale.april,
      context.locale.may,
      context.locale.june,
      context.locale.july,
      context.locale.august,
      context.locale.september,
      context.locale.october,
      context.locale.november,
      context.locale.december,
    ];
    return '${months[month - 1]} $year';
  }

  /// Gets the start of the week (Monday)
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1));
  }

  /// Gets the end of the week (Sunday)
  DateTime get endOfWeek {
    return startOfWeek.add(const Duration(days: 6));
  }

  /// Formats week range as "Jan 15 - Jan 21"
  String toWeekRangeString(final BuildContext context) {
    return '${startOfWeek.toShortDateString(context)} - ${endOfWeek.toShortDateString(context)}';
  }
}

extension PeriodType on int {
  String getPeriodTitle(final BuildContext context, final DateTime date) {
    final DateTime now = DateTime.now();
    final bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    switch (this) {
      case 0:
        return isToday ? context.locale.today : date.toShortDateString(context);
      case 1:
        final bool isCurrentWeek =
            date.startOfWeek.isBefore(now.add(const Duration(days: 1))) &&
            date.endOfWeek.isAfter(now.subtract(const Duration(days: 1)));
        return isCurrentWeek
            ? context.locale.thisWeek
            : date.toWeekRangeString(context);
      case 2:
        final bool isCurrentMonth =
            date.year == now.year && date.month == now.month;
        return isCurrentMonth
            ? context.locale.thisMonth
            : date.toMonthYearString(context);
      default:
        return '';
    }
  }

  String getDateRangeText(final DateTime date, final BuildContext context) {
    switch (this) {
      case 0:
        return date.toShortDateString(context);
      case 1:
        return date.toWeekRangeString(context);
      case 2:
        return date.toMonthYearString(context);
      default:
        return '';
    }
  }
}

extension DateTimeX on DateTime {
  String formattedActivityTime(BuildContext context) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(year, month, day);

    final time = DateFormat(
      'hh:mm a',
      Localizations.localeOf(context).toString(),
    ).format(this);

    final l10n = AppLocalizations.of(context);

    if (date == today) {
      return '${l10n.today}, $time';
    }

    if (date == yesterday) {
      return '${l10n.yesterday}, $time';
    }

    return DateFormat(
      'dd MMM, hh:mm a',
      Localizations.localeOf(context).toString(),
    ).format(this);
  }
}
