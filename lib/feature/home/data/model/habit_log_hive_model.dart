import 'package:hive/hive.dart';
import 'package:routiner/core/enums/log_status.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';

part 'habit_log_hive_model.g.dart';

@HiveType(typeId: 2)
class HabitLogHiveModel {

  const HabitLogHiveModel({
    this.habitId,
    this.date,
    this.id,
    this.status,
    this.completedValue,
    this.goalValue,
    this.notes,
    this.completedAt,
  });
  factory HabitLogHiveModel.fromJson(final Map<String, dynamic> json) {
    return HabitLogHiveModel(
      id: json['id'] ?? '',
      habitId: json['habitId'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      completedValue: json['completedValue'] ?? 0,
      goalValue: json['goalValue'] ?? 0,
      notes: json['notes'] ?? '',
      completedAt: json['completedAt'] ?? '',
    );
  }
  /// ✅ Entity → HiveModel
  factory HabitLogHiveModel.fromEntity(final HabitLogEntity entity) {
    return HabitLogHiveModel(
      id: entity.id,
      habitId: entity.habitId,
      date: entity.date.toIso8601String().split('T')[0],
      status: entity.status.name,
      completedValue: entity.completedValue,
      goalValue: entity.goalValue,
      notes: entity.notes,
      completedAt: entity.completedAt?.toIso8601String(),
    );
  }

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? habitId;

  @HiveField(2)
  final String? date;

  @HiveField(3)
  final String? status;

  @HiveField(4)
  final int? completedValue;

  @HiveField(5)
  final int? goalValue;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final String? completedAt;

  HabitLogEntity toEntity() {
    return HabitLogEntity(
      id: id ?? '',
      habitId: habitId ?? '',
      date: (date != null && date!.isNotEmpty)
          ? DateTime.parse(date!)
          : DateTime.now(),
      status: LogStatus.values.firstWhere(
        (final LogStatus s) => s.name == status,
        orElse: () => LogStatus.pending,
      ),
      completedValue: completedValue,
      goalValue: goalValue,
      notes: notes,
      completedAt: completedAt != null && completedAt!.isNotEmpty
          ? DateTime.tryParse(completedAt!)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'habitId': habitId,
      'date': date,
      'status': status,
      'completedValue': completedValue,
      'goalValue': goalValue,
      'notes': notes,
      'completedAt': completedAt,
    };
  }

}
