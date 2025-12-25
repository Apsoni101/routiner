part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load the current authenticated user's profile
class LoadCurrentUserProfile extends ProfileEvent {
  const LoadCurrentUserProfile();
}

/// Load a specific user's profile by UID
class LoadProfile extends ProfileEvent {
  const LoadProfile({required this.uid});

  final String uid;

  @override
  List<Object?> get props => [uid];
}

/// Refresh the current authenticated user's profile
class RefreshCurrentUserProfile extends ProfileEvent {
  const RefreshCurrentUserProfile();
}

/// Refresh a specific user's profile by UID
class RefreshProfile extends ProfileEvent {
  const RefreshProfile({required this.uid});

  final String uid;

  @override
  List<Object?> get props => [uid];
}

/// Update the user's profile
class UpdateProfile extends ProfileEvent {
  const UpdateProfile({required this.profile});

  final UserEntity profile;

  @override
  List<Object?> get props => [profile];
}

/// Load activities for the current user
class LoadActivities extends ProfileEvent {
  const LoadActivities({this.limit});

  final int? limit;

  @override
  List<Object?> get props => [limit];
}

/// Load total points for the current user
class LoadTotalPoints extends ProfileEvent {
  const LoadTotalPoints();
}

/// Load achievements for the current user
class LoadAchievements extends ProfileEvent {
  const LoadAchievements();
}

/// Unlock a specific achievement
class UnlockAchievement extends ProfileEvent {
  const UnlockAchievement({required this.achievementId});

  final String achievementId;

  @override
  List<Object?> get props => [achievementId];
}

/// Initialize achievements for the current user
class InitializeAchievements extends ProfileEvent {
  const InitializeAchievements();
}

/// Clear cached profile data
class ClearProfileCache extends ProfileEvent {
  const ClearProfileCache();
}
