import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends UserEntity {
  const UserModel({
    @HiveField(0) super.uid,
    @HiveField(1) super.email,
    @HiveField(2) super.name,
    @HiveField(3) super.surname = '',
    @HiveField(4) super.birthdate = '',
  });

  factory UserModel.fromFirebaseUser(final User user) => UserModel(
    uid: user.uid,
    email: user.email ?? '',
    name: user.displayName ?? user.email?.split('@').first ?? '',
  );

  factory UserModel.fromFirestore({required final Map<String, dynamic> data}) =>
      UserModel(
        uid: data['uid']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
        name: data['name']?.toString() ?? '',
        surname: data['surname']?.toString() ?? '',
        birthdate: data['birthdate']?.toString() ?? '',
      );

  factory UserModel.fromHive(final Map<String, dynamic> data) => UserModel(
    uid: data['uid']?.toString() ?? '',
    email: data['email']?.toString() ?? '',
    name: data['name']?.toString() ?? '',
    surname: data['surname']?.toString() ?? '',
    birthdate: data['birthdate']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'name': name,
    'surname': surname,
    'birthdate': birthdate,
  };

  Map<String, dynamic> toHiveMap() => {
    'uid': uid,
    'email': email,
    'name': name,
    'surname': surname,
    'birthdate': birthdate,
  };
}
