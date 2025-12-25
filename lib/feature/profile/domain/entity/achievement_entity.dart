import 'package:routiner/core/enums/achievement_type.dart';

class AchievementEntity {
  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.tier,
    required this.targetValue,
    required this.currentProgress,
    required this.isUnlocked,
    required this.pointsReward,
    required this.iconPath,
    this.unlockedAt,
  });

  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final AchievementTier tier;
  final int targetValue;
  final int currentProgress;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int pointsReward;
  final String iconPath;

  bool get isCompleted => currentProgress >= targetValue;

  double get progressPercentage =>
      (currentProgress / targetValue * 100).clamp(0, 100);

  AchievementEntity copyWith({
    final String? id,
    final String? title,
    final String? description,
    final AchievementType? type,
    final AchievementTier? tier,
    final int? targetValue,
    final int? currentProgress,
    final bool? isUnlocked,
    final DateTime? unlockedAt,
    final int? pointsReward,
    final String? iconPath,
  }) {
    return AchievementEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      tier: tier ?? this.tier,
      targetValue: targetValue ?? this.targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      pointsReward: pointsReward ?? this.pointsReward,
      iconPath: iconPath ?? this.iconPath,
    );
  }
}
