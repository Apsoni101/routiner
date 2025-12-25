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
    @HiveField(5) super.isNewUser = false,
  });

  factory UserModel.fromFirestore({required final Map<String, dynamic> data}) =>
      UserModel(
        uid: data['uid']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
        name: data['name']?.toString() ?? '',
        surname: data['surname']?.toString() ?? '',
        birthdate: data['birthdate']?.toString() ?? '',
        isNewUser: false,
      );

  factory UserModel.fromFirebaseUser(final User user) {
    final bool isNewUser =
        user.metadata.creationTime == user.metadata.lastSignInTime;

    // Extract name and surname from Google account
    final String fullName =
        user.displayName ?? user.email?.split('@').first ?? '';
    final List<String> nameParts = fullName.split(' ');

    final String name = nameParts.isNotEmpty ? nameParts.first : '';
    final String surname = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';

    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: name,
      surname: surname,
      isNewUser: isNewUser,
    );
  }

  // 2. Update toJson() to include all fields
  Map<String, dynamic> toJson() => {
    'uid': uid ?? '',
    'email': email ?? '',
    'name': name ?? '',
    'surname': surname ?? '',
    'birthdate': birthdate ?? '',
    'isNewUser': isNewUser,
  };

  // 3. Update toHiveMap() to match
  Map<String, dynamic> toHiveMap() => {
    'uid': uid ?? '',
    'email': email ?? '',
    'name': name ?? '',
    'surname': surname ?? '',
    'birthdate': birthdate ?? '',
    'isNewUser': isNewUser,
  };

  @override
  UserModel copyWith({
    String? uid,
    String? name,
    String? surname,
    String? email,
    String? birthdate,
    bool? isNewUser,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      birthdate: birthdate ?? this.birthdate,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}
