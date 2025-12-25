// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************


class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      uid: reader.readString(),
      email: reader.readString(),
      name: reader.readString(),
      surname: reader.readString(),
      birthdate: reader.readString(),
      isNewUser: reader.readBool(),

    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(obj.uid ?? '');
    writer.writeString(obj.email ?? '');
    writer.writeString(obj.name ?? '');
    writer.writeString(obj.surname ?? '');
    writer.writeString(obj.birthdate ?? '');
    writer.writeBool(obj.isNewUser);

  }
}
