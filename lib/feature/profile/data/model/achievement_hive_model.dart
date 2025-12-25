import 'package:hive/hive.dart';
import 'package:routiner/core/enums/achievement_type.dart';
import 'package:routiner/feature/profile/domain/entity/achievement_entity.dart';

part 'achievement_hive_model.g.dart';

@HiveType(typeId: 7)
class AchievementHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String tier;

  @HiveField(5)
  final int targetValue;

  @HiveField(6)
  final int currentProgress;

  @HiveField(7)
  final bool isUnlocked;

  @HiveField(8)
  final String? unlockedAt;

  @HiveField(9)
  final int pointsReward;

  @HiveField(10)
  final String iconPath;

  const AchievementHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.tier,
    required this.targetValue,
    required this.currentProgress,
    required this.isUnlocked,
    this.unlockedAt,
    required this.pointsReward,
    required this.iconPath,
  });

  AchievementEntity toEntity() {
    final DateTime? parsedDate = (unlockedAt?.isNotEmpty ?? false)
        ? DateTime.tryParse(unlockedAt!) ?? null
        : null;

    return AchievementEntity(
      id: id,
      title: title,
      description: description,
      type: AchievementType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => AchievementType.habitStreak,
      ),
      tier: AchievementTier.values.firstWhere(
        (e) => e.name == tier,
        orElse: () => AchievementTier.bronze,
      ),
      targetValue: targetValue,
      currentProgress: currentProgress,
      isUnlocked: isUnlocked,
      unlockedAt: parsedDate,
      pointsReward: pointsReward,
      iconPath: iconPath,
    );
  }

  factory AchievementHiveModel.fromEntity(AchievementEntity entity) {
    return AchievementHiveModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      type: entity.type.name,
      tier: entity.tier.name,
      targetValue: entity.targetValue,
      currentProgress: entity.currentProgress,
      isUnlocked: entity.isUnlocked,
      unlockedAt: entity.unlockedAt?.toIso8601String(),
      pointsReward: entity.pointsReward,
      iconPath: entity.iconPath,
    );
  }
}
