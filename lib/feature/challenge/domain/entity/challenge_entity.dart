// lib/feature/challenge/domain/entity/challenge_entity.dart

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:routiner/core/enums/emojis.dart';

enum ChallengeDurationType { hours, days, weeks, months }

class ChallengeEntity extends Equatable {
  const ChallengeEntity({
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

  final String? id;
  final String? title;
  final String? description;
  final Emoji? emoji;
  final int? duration;
  final ChallengeDurationType? durationType;
  final List<String>? habitIds;
  final String? creatorId;
  final List<String>? participantIds;
  final DateTime? createdAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isActive;

  // Progress tracking
  final int? totalGoalValue;
  final int? completedValue;

  /// 📅 Example outputs:
  /// Same month  → May 28 to 30
  /// Different   → May 28 to 4 Jun
  String get dateRangeText {
    if (startDate == null || endDate == null) {
      return '';
    }

    final String startMonth = DateFormat('MMM').format(startDate!);
    final String endMonth = DateFormat('MMM').format(endDate!);

    final int startDay = startDate!.day;
    final int endDay = endDate!.day;

    if (startDate!.month == endDate!.month &&
        startDate!.year == endDate!.year) {
      return '$startMonth $startDay to $endDay';
    }

    return '$startMonth $startDay to $endDay $endMonth';
  }

  ChallengeEntity copyWith({
    final String? id,
    final String? title,
    final String? description,
    final Emoji? emoji,
    final int? duration,
    final ChallengeDurationType? durationType,
    final List<String>? habitIds,
    final String? creatorId,
    final List<String>? participantIds,
    final DateTime? createdAt,
    final DateTime? startDate,
    final DateTime? endDate,
    final bool? isActive,
    final int? totalGoalValue,
    final int? completedValue,
  }) {
    return ChallengeEntity(
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

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    description,
    emoji,
    duration,
    durationType,
    habitIds,
    creatorId,
    participantIds,
    createdAt,
    startDate,
    endDate,
    isActive,
    totalGoalValue,
    completedValue,
  ];
}
