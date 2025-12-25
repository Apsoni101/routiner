import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routiner/core/extensions/localization_extension.dart';


extension TimeOfDayDisplayExtension on TimeOfDay {
  String toDisplayText() {
    final int hour = hourOfPeriod == 0 ? 12 : hourOfPeriod;
    final String minuteText = minute.toString().padLeft(2, '0');
    final String periodText = period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minuteText $periodText';
  }
}

extension DateTimeMonthExtension on DateTime {
  List<DateTime> get daysOfMonth {
    final DateTime firstDay = DateTime(year, month, 1);
    final int daysInMonth = DateTime(year, month + 1, 0).day;

    return List.generate(
      daysInMonth,
      (final int index) => firstDay.add(Duration(days: index)),
    );
  }
}

extension DateTimeWeekdayLocaleExtension on DateTime {
  String shortWeekday(BuildContext context) {
    switch (weekday) {
      case DateTime.monday:
        return context.locale.weekdayMon;
      case DateTime.tuesday:
        return context.locale.weekdayTue;
      case DateTime.wednesday:
        return context.locale.weekdayWed;
      case DateTime.thursday:
        return context.locale.weekdayThu;
      case DateTime.friday:
        return context.locale.weekdayFri;
      case DateTime.saturday:
        return context.locale.weekdaySat;
      case DateTime.sunday:
      default:
        return context.locale.weekdaySun;
    }
  }
}

extension SafeDateParsing on String? {
  /// Safely parses a date string into DateTime.
  /// Supports ISO format (YYYY-MM-DD) and custom format (dd/MM/yy).
  DateTime? toSafeDate() {
    if (this == null) return null;

    // Try ISO format
    try {
      return DateTime.parse(this!);
    } catch (_) {}

    // Try dd/MM/yy format
    try {
      return DateFormat('dd/MM/yy').parse(this!);
    } catch (_) {}

    // Fallback
    return null;
  }
}


extension DateTimeFormatting on DateTime? {
  String formatUnlockDate() {
    if (this == null) {
      return 'recently';
    }

    try {
      final DateTime dateTime = this!;
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return 'today';
      }
      if (difference.inDays == 1) {
        return 'yesterday';
      }
      if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      }
      if (difference.inDays < 30) {
        final int weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      }

      return '${dateTime.day.toString().padLeft(2, '0')}/'
          '${dateTime.month.toString().padLeft(2, '0')}/'
          '${dateTime.year}';
    } catch (e) {
      return 'recently';
    }
  }
}