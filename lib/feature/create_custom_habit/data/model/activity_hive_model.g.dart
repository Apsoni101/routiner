// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_hive_model.dart';

class ActivityHiveModelAdapter extends TypeAdapter<ActivityHiveModel> {
  @override
  final int typeId = 6;

  @override
  ActivityHiveModel read(BinaryReader reader) {
    return ActivityHiveModel(
      id: reader.readString(),
      userId: reader.readString(),
      activityType: reader.readString(),
      points: reader.readInt(),
      description: reader.readString(),
      timestamp: reader.readString(),
      relatedHabitId: reader.readString(),
      relatedHabitName: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ActivityHiveModel obj) {
    writer.writeString(obj.id ?? '');
    writer.writeString(obj.userId ?? '');
    writer.writeString(obj.activityType ?? '');
    writer.writeInt(obj.points ?? 0);
    writer.writeString(obj.description ?? '');
    writer.writeString(obj.timestamp ?? '');
    writer.writeString(obj.relatedHabitId ?? '');
    writer.writeString(obj.relatedHabitName ?? '');
  }
}
