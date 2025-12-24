
import 'package:equatable/equatable.dart';
import 'package:routiner/core/enums/activity_type.dart';

class ActivityEntity extends Equatable {
  const ActivityEntity({
    required this.id,
    required this.userId,
    required this.activityType,
    required this.points,
    required this.description,
    required this.timestamp,
    this.relatedHabitId,
    this.relatedHabitName,
  });

  final String id;
  final String userId;
  final ActivityType activityType;
  final int points;
  final String description;
  final DateTime timestamp;
  final String? relatedHabitId;
  final String? relatedHabitName;

  @override
  List<Object?> get props => [
    id,
    userId,
    activityType,
    points,
    description,
    timestamp,
    relatedHabitId,
    relatedHabitName,
  ];
}