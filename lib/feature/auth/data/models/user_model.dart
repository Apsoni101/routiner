import 'package:firebase_auth/firebase_auth.dart';
import 'package:routiner/core/services/storage/shared_prefs_keys.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';

///responsible for converting firebase user to UserEntity
class UserModel extends UserEntity {
  ///creates an instance of userModel
  const UserModel({
    required super.uid,
    required super.email,
    required super.name,
  });

  factory UserModel.fromFirestore({required final Map<String, dynamic> data}) =>
      UserModel(
        uid: data['uid'] ?? '',
        email: data['email'] ?? '',
        name: data['name'] ?? '',
      );

  ///responsible for converting firebase user to UserEntity
  factory UserModel.fromFirebaseUser(final User user) => UserModel(
    uid: user.uid,
    email: user.email ?? '',
    name: user.displayName ?? '',
  );

  factory UserModel.fromSharedPrefs(final Map<String, String?> data) => UserModel(
      uid: data[SharedPrefsKeys.userUid]??'',
      email: data[SharedPrefsKeys.userEmail]??'',
      name: data[SharedPrefsKeys.userName]??'',
    );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid': uid,
    'email': email,
    'name': name,
  };
}
