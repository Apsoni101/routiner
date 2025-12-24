// lib/feature/challenge/data/model/challenge_hive_model.dart

import 'package:hive/hive.dart';
import 'package:routiner/core/enums/emojis.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';

part 'challenge_hive_model.g.dart';

@HiveType(typeId: 10) // Use appropriate typeId that's not already used
class ChallengeHiveModel extends HiveObject {

  // From Entity
  factory ChallengeHiveModel.fromEntity(final ChallengeEntity entity) {
    return ChallengeHiveModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      emoji: entity.emoji?.symbol,
      duration: entity.duration,
      durationType: entity.durationType?.name,
      habitIds: entity.habitIds,
      creatorId: entity.creatorId,
      participantIds: entity.participantIds,
      createdAt: entity.createdAt?.toIso8601String(),
      startDate: entity.startDate?.toIso8601String(),
      endDate: entity.endDate?.toIso8601String(),
      isActive: entity.isActive,
      totalGoalValue: entity.totalGoalValue,
      completedValue: entity.completedValue,
    );
  }

  ChallengeHiveModel({
    this.id,
    this.title,
    this.description,
    this.emoji,
    this.duration,
    this.durationType,
    this.habitIds,
    this.creatorId,
    this.participantIds,
    this.createdAt,
    this.startDate,
    this.endDate,
    this.isActive,
    this.totalGoalValue,
    this.completedValue,
  });

  // From JSON (for compatibility with existing code)
  factory ChallengeHiveModel.fromJson(final Map<String, dynamic> json) {
    return ChallengeHiveModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      emoji: json['emoji'] as String?,
      duration: json['duration'] as int?,
      durationType: json['durationType'] as String?,
      habitIds: (json['habitIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      creatorId: json['creatorId'] as String?,
      participantIds: (json['participantIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      createdAt: json['createdAt'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      isActive: json['isActive'] as bool?,
      totalGoalValue: json['totalGoalValue'] as int?,
      completedValue: json['completedValue'] as int?,
    );
  }
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? emoji;

  @HiveField(4)
  final int? duration;

  @HiveField(5)
  final String? durationType;

  @HiveField(6)
  final List<String>? habitIds;

  @HiveField(7)
  final String? creatorId;

  @HiveField(8)
  final List<String>? participantIds;

  @HiveField(9)
  final String? createdAt;

  @HiveField(10)
  final String? startDate;

  @HiveField(11)
  final String? endDate;

  @HiveField(12)
  final bool? isActive;

  @HiveField(13)
  final int? totalGoalValue;

  @HiveField(14)
  final int? completedValue;

  // To Entity
  ChallengeEntity toEntity() {
    return ChallengeEntity(
      id: id,
      title: title,
      description: description,
      emoji: emoji != null
          ? Emoji.values.cast<Emoji?>().firstWhere(
              (e) => e!.symbol == emoji,
              orElse: () => null,
            )
          : null,
      duration: duration,
      durationType: durationType != null
          ? ChallengeDurationType.values.firstWhere(
              (final e) => e.name == durationType,
              orElse: () => ChallengeDurationType.days,
            )
          : null,
      habitIds: habitIds,
      creatorId: creatorId,
      participantIds: participantIds,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      startDate: startDate != null ? DateTime.tryParse(startDate!) : null,
      endDate: endDate != null ? DateTime.tryParse(endDate!) : null,
      isActive: isActive,
      totalGoalValue: totalGoalValue,
      completedValue: completedValue,
    );
  }

  // To JSON (for compatibility with existing code)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'emoji': emoji,
      'duration': duration,
      'durationType': durationType,
      'habitIds': habitIds,
      'creatorId': creatorId,
      'participantIds': participantIds,
      'createdAt': createdAt,
      'startDate': startDate,
      'endDate': endDate,
      'isActive': isActive,
      'totalGoalValue': totalGoalValue,
      'completedValue': completedValue,
    };
  }

  ChallengeHiveModel copyWith({
    final String? id,
    final String? title,
    final String? description,
    final String? emoji,
    final int? duration,
    final String? durationType,
    final List<String>? habitIds,
    final String? creatorId,
    final List<String>? participantIds,
    final String? createdAt,
    final String? startDate,
    final String? endDate,
    final bool? isActive,
    final int? totalGoalValue,
    final int? completedValue,
  }) {
    return ChallengeHiveModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      duration: duration ?? this.duration,
      durationType: durationType ?? this.durationType,
      habitIds: habitIds ?? this.habitIds,
      creatorId: creatorId ?? this.creatorId,
      participantIds: participantIds ?? this.participantIds,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      totalGoalValue: totalGoalValue ?? this.totalGoalValue,
      completedValue: completedValue ?? this.completedValue,
    );
  }
}
