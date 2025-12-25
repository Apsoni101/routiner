// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AchievementHiveModelAdapter
    extends TypeAdapter<AchievementHiveModel> {
  @override
  final int typeId = 7;

  @override
  AchievementHiveModel read(BinaryReader reader) {
    return AchievementHiveModel(
      id: reader.readString(),
      title: reader.readString(),
      description: reader.readString(),
      type: reader.readString(),
      tier: reader.readString(),
      targetValue: reader.readInt(),
      currentProgress: reader.readInt(),
      isUnlocked: reader.readBool(),
      unlockedAt: reader.readString(),
      pointsReward: reader.readInt(),
      iconPath: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, AchievementHiveModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeString(obj.type);
    writer.writeString(obj.tier);
    writer.writeInt(obj.targetValue);
    writer.writeInt(obj.currentProgress);
    writer.writeBool(obj.isUnlocked);
    writer.writeString(obj.unlockedAt ?? ''); // Keeps original format
    writer.writeInt(obj.pointsReward);
    writer.writeString(obj.iconPath);
  }
}