// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_log_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************


class HabitLogHiveModelAdapter extends TypeAdapter<HabitLogHiveModel> {
  @override
  final int typeId = 2;

  @override
  HabitLogHiveModel read(BinaryReader reader) {
    return HabitLogHiveModel(
      id: reader.readString(),
      habitId: reader.readString(),
      date: reader.readString(),
      status: reader.readString(),
      completedValue: reader.readInt(),
      goalValue: reader.readInt(),
      notes: reader.readString(),
      completedAt: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, HabitLogHiveModel obj) {
    writer.writeString(obj.id ?? '');
    writer.writeString(obj.habitId ?? '');
    writer.writeString(obj.date ?? '');
    writer.writeString(obj.status ?? '');
    writer.writeInt(obj.completedValue ?? 0);
    writer.writeInt(obj.goalValue ?? 0);
    writer.writeString(obj.notes ?? '');
    writer.writeString(obj.completedAt ?? '');
  }
}
