// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_habit_hive_model.dart';

class CustomHabitHiveModelAdapter
    extends TypeAdapter<CustomHabitHiveModel> {
  @override
  final int typeId = 1;

  @override
  CustomHabitHiveModel read(BinaryReader reader) {
    return CustomHabitHiveModel(
      id: reader.readString(),
      name: reader.readString(),
      iconCodePoint: reader.readInt(),
      habitIcon: reader.readString(),
      colorValue: reader.readInt(),
      goal: reader.readString(),
      reminders: reader.readList()?.cast<String>(),
      type: reader.readString(),
      location: reader.readString(),
      createdAt: reader.readString(),
      goalValue: reader.readInt(),
      goalUnit: reader.readString(),
      goalFrequency: reader.readString(),
      goalDays: reader.readList()?.cast<String>(),
      isAlarmEnabled: reader.readBool(),
      alarmTime: reader.readString(),
      alarmDays: reader.readList()?.cast<String>(),
      habitIconPath: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, CustomHabitHiveModel obj) {
    writer.writeString(obj.id ?? '');
    writer.writeString(obj.name ?? '');
    writer.writeInt(obj.iconCodePoint ?? 0);
    writer.writeString(obj.habitIcon ?? '');
    writer.writeInt(obj.colorValue ?? 0);
    writer.writeString(obj.goal ?? '');
    writer.writeList(obj.reminders ?? []);
    writer.writeString(obj.type ?? '');
    writer.writeString(obj.location ?? '');
    writer.writeString(obj.createdAt ?? '');
    writer.writeInt(obj.goalValue ?? 0);
    writer.writeString(obj.goalUnit ?? '');
    writer.writeString(obj.goalFrequency ?? '');
    writer.writeList(obj.goalDays ?? []);
    writer.writeBool(obj.isAlarmEnabled ?? false);
    writer.writeString(obj.alarmTime ?? '');
    writer.writeList(obj.alarmDays ?? []);
    writer.writeString(obj.habitIconPath ?? '');
  }
}
