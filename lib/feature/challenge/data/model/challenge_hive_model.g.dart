// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChallengeHiveModelAdapter extends TypeAdapter<ChallengeHiveModel> {
  @override
  final int typeId = 3;

  @override
  ChallengeHiveModel read(BinaryReader reader) {
    return ChallengeHiveModel(
      id: reader.readString(),
      title: reader.readString(),
      description: reader.readString(),
      emoji: reader.readString(),
      duration: reader.readInt(),
      durationType: reader.readString(),
      habitIds: reader.readList().cast<String>(),
      creatorId: reader.readString(),
      participantIds: reader.readList().cast<String>(),
      createdAt: reader.readString(),
      startDate: reader.readString(),
      endDate: reader.readString(),
      isActive: reader.readBool(),
      totalGoalValue: reader.readInt(),
      completedValue: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ChallengeHiveModel obj) {
    writer.writeString(obj.id ?? '');
    writer.writeString(obj.title ?? '');
    writer.writeString(obj.description ?? '');
    writer.writeString(obj.emoji ?? '');
    writer.writeInt(obj.duration ?? 0);
    writer.writeString(obj.durationType ?? '');
    writer.writeList(obj.habitIds ?? <String>[]);
    writer.writeString(obj.creatorId ?? '');
    writer.writeList(obj.participantIds ?? <String>[]);
    writer.writeString(obj.createdAt ?? '');
    writer.writeString(obj.startDate ?? '');
    writer.writeString(obj.endDate ?? '');
    writer.writeBool(obj.isActive ?? false);
    writer.writeInt(obj.totalGoalValue ?? 0);
    writer.writeInt(obj.completedValue ?? 0);
  }
}
