
import 'package:hive/hive.dart';
import 'package:routiner/core/enums/activity_type.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/activity_entity.dart';

part 'activity_hive_model.g.dart';

@HiveType(typeId: 6)
class ActivityHiveModel {
  const ActivityHiveModel({
    this.id,
    this.userId,
    this.activityType,
    this.points,
    this.description,
    this.timestamp,
    this.relatedHabitId,
    this.relatedHabitName,
  });

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? userId;

  @HiveField(2)
  final String? activityType; // stored as enum name

  @HiveField(3)
  final int? points;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final String? timestamp; // stored as ISO8601 string

  @HiveField(6)
  final String? relatedHabitId;

  @HiveField(7)
  final String? relatedHabitName;

  // Convert HiveModel → Entity
  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id ?? '',
      userId: userId ?? '',
      activityType: activityType != null && activityType!.isNotEmpty
          ? ActivityType.values.firstWhere(
            (e) => e.name == activityType,
        orElse: () => ActivityType.habitCreated,
      )
          : ActivityType.habitCreated,
      points: points ?? 0,
      description: description ?? '',
      timestamp: timestamp != null && timestamp!.isNotEmpty
          ? DateTime.tryParse(timestamp!) ?? DateTime.now()
          : DateTime.now(),
      relatedHabitId: relatedHabitId,
      relatedHabitName: relatedHabitName,
    );
  }

  // Convert Entity → HiveModel
  factory ActivityHiveModel.fromEntity(ActivityEntity entity) {
    return ActivityHiveModel(
      id: entity.id,
      userId: entity.userId,
      activityType: entity.activityType.name,
      points: entity.points,
      description: entity.description,
      timestamp: entity.timestamp.toIso8601String(),
      relatedHabitId: entity.relatedHabitId,
      relatedHabitName: entity.relatedHabitName,
    );
  }
}