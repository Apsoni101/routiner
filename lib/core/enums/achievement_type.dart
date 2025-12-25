import 'package:flutter/material.dart';

enum AchievementTier {
  bronze('Bronze', Color(0xFFCD7F32)),
  silver('Silver', Color(0xFFC0C0C0)),
  gold('Gold', Color(0xFFFFD700)),
  platinum('Platinum', Color(0xFFE5E4E2));

  const AchievementTier(this.label, this.color);

  final String label;
  final Color color;
}
enum AchievementType {
  habitStreak,
  totalHabits,
  challengeWin,
  pointsMilestone,
  perfectWeek,
  earlyBird,
  socialButterfly,
  consistency,
}
