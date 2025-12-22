import 'package:equatable/equatable.dart';

/// Entity representing a friend relationship
class FriendEntity extends Equatable {
  /// Creates an instance of FriendEntity
  const FriendEntity({
    required this.uid,
    required this.name,
    required this.surname,
    this.email,
    this.birthdate,
    this.addedAt,
  });

  /// Unique user id of the friend
  final String uid;

  /// Friend's name
  final String name;

  /// Friend's surname
  final String surname;

  /// Friend's email
  final String? email;

  /// Friend's birthdate
  final String? birthdate;

  /// Timestamp when friend was added
  final DateTime? addedAt;

  @override
  List<Object?> get props => <Object?>[
    uid,
    name,
    surname,
    email,
    birthdate,
    addedAt,
  ];

  /// Copy with method for entity
  FriendEntity copyWith({
    final String? uid,
    final String? name,
    final String? surname,
    final String? email,
    final String? birthdate,
    final DateTime? addedAt,
  }) {
    return FriendEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      birthdate: birthdate ?? this.birthdate,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  /// Get full name
  String get fullName => '$name $surname';
}
