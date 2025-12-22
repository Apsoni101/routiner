import 'package:flutter/material.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

enum Day {
  everyday,
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}


extension DayLocalization on Day {
  String label(final BuildContext context) {
    switch (this) {
      case Day.everyday:
        return context.locale.everyday;
      case Day.sunday:
        return context.locale.sunday;
      case Day.monday:
        return context.locale.monday;
      case Day.tuesday:
        return context.locale.tuesday;
      case Day.wednesday:
        return context.locale.wednesday;
      case Day.thursday:
        return context.locale.thursday;
      case Day.friday:
        return context.locale.friday;
      case Day.saturday:
        return context.locale.saturday;
    }
  }
}
