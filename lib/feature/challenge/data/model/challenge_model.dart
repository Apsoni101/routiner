// lib/feature/challenge/data/model/challenge_model.dart

import 'package:routiner/core/enums/emojis.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';

class ChallengeModel extends ChallengeEntity {
  const ChallengeModel({
    super.id,
    super.title,
    super.description,
    super.emoji,
    super.duration,
    super.durationType,
    super.habitIds,
    super.creatorId,
    super.participantIds,
    super.createdAt,
    super.startDate,
    super.endDate,
    super.isActive,
    super.totalGoalValue,
    super.completedValue,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      emoji: _parseEmoji(json['emoji'] ?? '😀'),
      duration: json['duration'] ?? 0,
      durationType: _parseDurationType(json['durationType'] ?? 'days'),
      habitIds: List<String>.from(json['habitIds'] ?? []),
      creatorId: json['creatorId'] ?? '',
      participantIds: List<String>.from(json['participantIds'] ?? []),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      startDate: DateTime.tryParse(json['startDate'] ?? ''),
      endDate: DateTime.tryParse(json['endDate'] ?? ''),
      isActive: json['isActive'] ?? true,
      totalGoalValue: json['totalGoalValue'] as int?,
      completedValue: json['completedValue'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'title': title ?? '',
      'description': description ?? '',
      'emoji': (emoji ?? Emoji.grinningFace).symbol,
      'duration': duration ?? 0,
      'durationType': (durationType ?? ChallengeDurationType.days).name,
      'habitIds': habitIds ?? [],
      'creatorId': creatorId ?? '',
      'participantIds': participantIds ?? [],
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive ?? true,
      'totalGoalValue': totalGoalValue,
      'completedValue': completedValue,
    };
  }

  /// Model → Entity
  ChallengeEntity toEntity() {
    return ChallengeEntity(
      id: id ?? '',
      title: title ?? '',
      description: description ?? '',
      emoji: emoji ?? Emoji.grinningFace,
      duration: duration ?? 0,
      durationType: durationType ?? ChallengeDurationType.days,
      habitIds: habitIds ?? [],
      creatorId: creatorId ?? '',
      participantIds: participantIds ?? [],
      createdAt: createdAt ?? DateTime.now(),
      startDate: startDate,
      endDate: endDate,
      isActive: isActive ?? true,
      totalGoalValue: totalGoalValue,
      completedValue: completedValue,
    );
  }

  /// Entity → Model
  factory ChallengeModel.fromEntity(ChallengeEntity entity) {
    return ChallengeModel(
      id: entity.id ?? '',
      title: entity.title ?? '',
      description: entity.description ?? '',
      emoji: entity.emoji ?? Emoji.grinningFace,
      duration: entity.duration ?? 0,
      durationType: entity.durationType ?? ChallengeDurationType.days,
      habitIds: entity.habitIds ?? [],
      creatorId: entity.creatorId ?? '',
      participantIds: entity.participantIds ?? [],
      createdAt: entity.createdAt ?? DateTime.now(),
      startDate: entity.startDate,
      endDate: entity.endDate,
      isActive: entity.isActive ?? true,
      totalGoalValue: entity.totalGoalValue,
      completedValue: entity.completedValue,
    );
  }

  static Emoji _parseEmoji(String symbol) {
    return Emoji.values.firstWhere(
          (e) => e.symbol == symbol,
      orElse: () => Emoji.grinningFace,
    );
  }

  static ChallengeDurationType _parseDurationType(String type) {
    return ChallengeDurationType.values.firstWhere(
          (e) => e.name == type,
      orElse: () => ChallengeDurationType.days,
    );
  }
}