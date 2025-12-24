// lib/feature/add_habit/domain/entity/mood_log_entity.dart

import 'package:equatable/equatable.dart';
import 'package:routiner/feature/add_habit/data/model/mood_log_model.dart';

class MoodLogEntity extends Equatable {
  const MoodLogEntity({
    this.id,
    required this.mood,
    required this.timestamp,
  });

  final String? id;
  final String mood;
  final DateTime timestamp;

  MoodLogModel toModel() {
    return MoodLogModel(
      id: id,
      mood: mood,
      timestamp: timestamp,
    );
  }

  MoodLogEntity copyWith({
    final String? id,
    final String? mood,
    final DateTime? timestamp,
  }) {
    return MoodLogEntity(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, mood, timestamp];
}