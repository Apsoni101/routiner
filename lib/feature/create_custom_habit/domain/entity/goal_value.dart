import 'package:flutter/material.dart';
import 'package:routiner/core/enums/goal_unit.dart';

class GoalValue {

  const GoalValue({required this.value, required this.unit});
  final int value;
  final GoalUnit unit;
}

extension GoalValueExtension on GoalValue {
  String displayText(final BuildContext context) {
    return '$value ${unit.label(context)}';
  }
}
