import 'package:equatable/equatable.dart';

///entity of user for only showing or exposing required properties that's used
class UserEntity extends Equatable {
  ///creates an instance of userEntity
  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
  });

  ///unique user id
  final String uid;

  ///user name
  final String name;

  ///user email
  final String email;

  @override
  List<Object?> get props => <Object?>[uid, email];
}
