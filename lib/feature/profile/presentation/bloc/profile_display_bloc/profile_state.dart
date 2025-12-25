part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.profile,
    this.activities,
    this.totalPoints,
    this.achievements,
    this.isRefreshing = false,
  });

  final UserEntity profile;
  final List<ActivityEntity>? activities;
  final int? totalPoints;
  final List<AchievementEntity>? achievements;
  final bool isRefreshing;

  @override
  List<Object?> get props => [profile, activities, totalPoints, achievements, isRefreshing];

  /// Create a copy with updated fields
  ProfileLoaded copyWith({
    UserEntity? profile,
    List<ActivityEntity>? activities,
    int? totalPoints,
    List<AchievementEntity>? achievements,
    bool? isRefreshing,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      activities: activities ?? this.activities,
      totalPoints: totalPoints ?? this.totalPoints,
      achievements: achievements ?? this.achievements,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class ProfileError extends ProfileState {
  const ProfileError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class ProfileUpdating extends ProfileState {
  const ProfileUpdating();
}

class ProfileUpdateSuccess extends ProfileState {
  const ProfileUpdateSuccess({required this.profile});

  final UserEntity profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateError extends ProfileState {
  const ProfileUpdateError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class ActivitiesLoading extends ProfileState {
  const ActivitiesLoading();
}

class ActivitiesLoaded extends ProfileState {
  const ActivitiesLoaded({required this.activities});

  final List<ActivityEntity> activities;

  @override
  List<Object?> get props => [activities];
}

class ActivitiesError extends ProfileState {
  const ActivitiesError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class AchievementsLoading extends ProfileState {
  const AchievementsLoading();
}

class AchievementsLoaded extends ProfileState {
  const AchievementsLoaded({required this.achievements});

  final List<AchievementEntity> achievements;

  @override
  List<Object?> get props => [achievements];
}

class AchievementsError extends ProfileState {
  const AchievementsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class AchievementUnlocked extends ProfileState {
  const AchievementUnlocked({
    required this.achievementId,
    required this.achievements,
  });

  final String achievementId;
  final List<AchievementEntity> achievements;

  @override
  List<Object?> get props => [achievementId, achievements];
}

class AchievementsInitialized extends ProfileState {
  const AchievementsInitialized();
}