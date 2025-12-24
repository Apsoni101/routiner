// lib/feature/add_habit/data/model/mood_log_hive_model.dart

import 'package:hive/hive.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';

part 'mood_log_hive_model.g.dart';

@HiveType(typeId: 5) // Use typeId 2 since CustomHabitHiveModel uses 1
class MoodLogHiveModel {
  const MoodLogHiveModel({
    this.id,
    required this.mood,
    required this.timestamp,
  });

  /// Convert Entity → HiveModel
  factory MoodLogHiveModel.fromEntity(final MoodLogEntity entity) {
    return MoodLogHiveModel(
      id: entity.id,
      mood: entity.mood,
      timestamp: entity.timestamp.toIso8601String(),
    );
  }

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String mood;

  @HiveField(2)
  final String timestamp; // Store as ISO8601 string

  /// Convert HiveModel → Entity
  MoodLogEntity toEntity() {
    return MoodLogEntity(
      id: id,
      mood: mood,
      timestamp: DateTime.parse(timestamp),
    );
  }

  /// Copy with method for updates
  MoodLogHiveModel copyWith({
    final String? id,
    final String? mood,
    final String? timestamp,
  }) {
    return MoodLogHiveModel(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}