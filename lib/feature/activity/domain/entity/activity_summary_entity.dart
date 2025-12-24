import 'package:equatable/equatable.dart';

/// Domain entity for activity summary statistics
class ActivitySummaryEntity extends Equatable {
  const ActivitySummaryEntity({
    required this.successRate,
    required this.completed,
    required this.failed,
    required this.skipped,
    required this.bestStreakDay,
    required this.pointsEarned,
  });

  final double successRate;
  final int completed;
  final int failed;
  final int skipped;
  final int bestStreakDay;
  final int pointsEarned;

  @override
  List<Object?> get props => <Object?>[
    successRate,
    completed,
    failed,
    skipped,
    bestStreakDay,
    pointsEarned,
  ];

  ActivitySummaryEntity copyWith({
    final double? successRate,
    final int? completed,
    final int? failed,
    final int? skipped,
    final int? bestStreakDay,
    final int? pointsEarned,
  }) {
    return ActivitySummaryEntity(
      successRate: successRate ?? this.successRate,
      completed: completed ?? this.completed,
      failed: failed ?? this.failed,
      skipped: skipped ?? this.skipped,
      bestStreakDay: bestStreakDay ?? this.bestStreakDay,
      pointsEarned: pointsEarned ?? this.pointsEarned,
    );
  }
}
