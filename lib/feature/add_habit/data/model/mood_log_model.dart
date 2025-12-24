// lib/feature/add_habit/data/model/mood_log_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routiner/feature/add_habit/domain/entity/mood_log_entity.dart';

class MoodLogModel extends MoodLogEntity {
  const MoodLogModel({
    String? id,
    required String mood,
    required DateTime timestamp,
  }) : super(id: id, mood: mood, timestamp: timestamp);

  factory MoodLogModel.fromJson(final Map<String, dynamic> json) {
    return MoodLogModel(
      id: json['id'] as String?,
      mood: json['mood'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'mood': mood,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory MoodLogModel.fromEntity(final MoodLogEntity entity) {
    return MoodLogModel(
      id: entity.id,
      mood: entity.mood,
      timestamp: entity.timestamp,
    );
  }
  MoodLogEntity toEntity() {
    return MoodLogEntity(
      id: id,
      mood: mood,
      timestamp: timestamp,
    );
  }


}
