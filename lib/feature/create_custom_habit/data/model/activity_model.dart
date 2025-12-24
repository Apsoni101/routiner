import 'package:routiner/core/enums/activity_type.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  const ActivityModel({
    required super.id,
    required super.userId,
    required super.activityType,
    required super.points,
    required super.description,
    required super.timestamp,
    super.relatedHabitId,
    super.relatedHabitName,
  });

  // Model → Entity
  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id,
      userId: userId,
      activityType: activityType,
      points: points,
      description: description,
      timestamp: timestamp,
      relatedHabitId: relatedHabitId,
      relatedHabitName: relatedHabitName,
    );
  }

  // Entity → Model
  factory ActivityModel.fromEntity(final ActivityEntity entity) {
    return ActivityModel(
      id: entity.id,
      userId: entity.userId,
      activityType: entity.activityType,
      points: entity.points,
      description: entity.description,
      timestamp: entity.timestamp,
      relatedHabitId: entity.relatedHabitId,
      relatedHabitName: entity.relatedHabitName,
    );
  }

  // Model → JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'activityType': activityType.name,
      'points': points,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'relatedHabitId': relatedHabitId,
      'relatedHabitName': relatedHabitName,
    };
  }

  // JSON → Model (NO `as`, uses ?? defaults)
  factory ActivityModel.fromJson(final Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      activityType: ActivityType.values.firstWhere(
        (final ActivityType e) => e.name == json['activityType']?.toString(),
        orElse: () => ActivityType.habitCreated,
      ),
      points: json['points'] ?? 0,
      description: json['description']?.toString() ?? '',
      timestamp:
          DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      relatedHabitId: json['relatedHabitId']?.toString(),
      relatedHabitName: json['relatedHabitName']?.toString(),
    );
  }
}
