
// presentation/bloc/profile_bloc/profile_event.dart
part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile({required this.uid});

  final String uid;

  @override
  List<Object?> get props => [uid];
}

class RefreshProfile extends ProfileEvent {
  const RefreshProfile({required this.uid});

  final String uid;

  @override
  List<Object?> get props => [uid];
}

class UpdateProfile extends ProfileEvent {
  const UpdateProfile({required this.profile});

  final UserEntity profile;

  @override
  List<Object?> get props => [profile];
}