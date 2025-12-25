import 'package:routiner/core/enums/achievement_type.dart';
import 'package:routiner/feature/profile/domain/entity/achievement_entity.dart';

class AchievementModel extends AchievementEntity {

  const AchievementModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.tier,
    required super.targetValue,
    required super.currentProgress,
    required super.isUnlocked,
    required super.pointsReward,
    required super.iconPath,
    super.unlockedAt,
  });
  factory AchievementModel.fromEntity(final AchievementEntity entity) {
    return AchievementModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      type: entity.type,
      tier: entity.tier,
      targetValue: entity.targetValue,
      currentProgress: entity.currentProgress,
      isUnlocked: entity.isUnlocked,
      unlockedAt: entity.unlockedAt,
      pointsReward: entity.pointsReward,
      iconPath: entity.iconPath,
    );
  }

  factory AchievementModel.fromJson(final Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: AchievementType.values.firstWhere(
            (e) => e.name == (json['type'] ?? ''),
        orElse: () => AchievementType.habitStreak,
      ),
      tier: AchievementTier.values.firstWhere(
            (e) => e.name == (json['tier'] ?? ''),
        orElse: () => AchievementTier.bronze,
      ),
      targetValue: json['targetValue'] ?? 0,
      currentProgress: json['currentProgress'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'])
          : null,
      pointsReward: json['pointsReward'] ?? 0,
      iconPath: json['iconPath'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'tier': tier.name,
      'targetValue': targetValue,
      'currentProgress': currentProgress,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'pointsReward': pointsReward,
      'iconPath': iconPath,
    };
  }

  /// Model ➜ Entity
  AchievementEntity toEntity() {
    return AchievementEntity(
      id: id,
      title: title,
      description: description,
      type: type,
      tier: tier,
      targetValue: targetValue,
      currentProgress: currentProgress,
      isUnlocked: isUnlocked,
      unlockedAt: unlockedAt,
      pointsReward: pointsReward,
      iconPath: iconPath,
    );
  }
}
