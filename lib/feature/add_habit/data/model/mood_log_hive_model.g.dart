// lib/feature/add_habit/data/model/mood_log_hive_model.g.dart

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_log_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodLogHiveModelAdapter extends TypeAdapter<MoodLogHiveModel> {
  @override
  final int typeId = 4;

  @override
  MoodLogHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoodLogHiveModel(
      id: fields[0] as String?,
      mood: fields[1] as String,
      timestamp: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MoodLogHiveModel obj) {
    writer
      ..writeByte(3) // number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mood)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MoodLogHiveModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}