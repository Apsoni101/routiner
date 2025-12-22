import 'package:flutter/material.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

enum RepeatInterval {
  daily,
  weekly,
  monthly,
}


extension RepeatIntervalLocalization on RepeatInterval {
  String label(BuildContext context) {
    switch (this) {
      case RepeatInterval.daily:
        return context.locale.daily;
      case RepeatInterval.weekly:
        return context.locale.weekly;
      case RepeatInterval.monthly:
        return context.locale.monthly;
    }
  }
}
