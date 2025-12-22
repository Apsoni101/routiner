import 'package:flutter/material.dart';

enum Mood {
  angry('Angry', '😡', Colors.red),
  sad('Sad', '☹️', Colors.blue),
  neutral('Neutral', '😐', Colors.grey),
  happy('Happy', '🙂', Colors.green),
  love('Love', '😍', Colors.pink);

  const Mood(this.label, this.emoji, this.color);

  final String label;
  final String emoji;
  final Color color;

  /// Color with 50% opacity
  Color get color50 => color.withOpacity(0.5);

  /// Convert from label or emoji to Mood safely
  static Mood? fromString(final String? value) {
    if (value == null) {
      return null;
    }

    for (final Mood mood in Mood.values) {
      if (mood.label == value || mood.emoji == value) {
        return mood;
      }
    }

    return null;
  }
}
