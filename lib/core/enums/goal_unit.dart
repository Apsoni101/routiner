import 'package:flutter/material.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

enum GoalUnit {
  times(
    maxValue: 10,
    step: 1,
  ),
  ml(
    maxValue: 5000,
    step: 100,
  ),
  steps(
    maxValue: 20000,
    step: 500,
  ),
  minutes(
    maxValue: 300,
    step: 5,
  ),
  hours(
    maxValue: 12,
    step: 1,
  ),
  pages(
    maxValue: 100,
    step: 5,
  ),

  // 🔽 New 10 units
  calories(
    maxValue: 5000,
    step: 50,
  ),
  kilometers(
    maxValue: 50,
    step: 1,
  ),
  meters(
    maxValue: 10000,
    step: 100,
  ),
  seconds(
    maxValue: 3600,
    step: 10,
  ),
  repetitions(
    maxValue: 200,
    step: 5,
  ),
  glasses(
    maxValue: 20,
    step: 1,
  ),
  sessions(
    maxValue: 10,
    step: 1,
  ),
  words(
    maxValue: 5000,
    step: 100,
  ),
  chapters(
    maxValue: 50,
    step: 1,
  ),
  items(
    maxValue: 100,
    step: 1,
  );

  const GoalUnit({
    required this.maxValue,
    required this.step,
  });

  final int maxValue;
  final int step;

  String label(BuildContext context) {
    switch (this) {
      case GoalUnit.times:
        return context.locale.times;
      case GoalUnit.ml:
        return context.locale.ml;
      case GoalUnit.steps:
        return context.locale.steps;
      case GoalUnit.minutes:
        return context.locale.minutes;
      case GoalUnit.hours:
        return context.locale.hours;
      case GoalUnit.pages:
        return context.locale.pages;
      case GoalUnit.calories:
        return context.locale.calories;
      case GoalUnit.kilometers:
        return context.locale.kilometers;
      case GoalUnit.meters:
        return context.locale.meters;
      case GoalUnit.seconds:
        return context.locale.seconds;
      case GoalUnit.repetitions:
        return context.locale.repetitions;
      case GoalUnit.glasses:
        return context.locale.glasses;
      case GoalUnit.sessions:
        return context.locale.sessions;
      case GoalUnit.words:
        return context.locale.words;
      case GoalUnit.chapters:
        return context.locale.chapters;
      case GoalUnit.items:
        return context.locale.items;
    }
  }
}
