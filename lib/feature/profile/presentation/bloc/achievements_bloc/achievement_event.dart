part of 'achievement_bloc.dart';

@immutable
sealed class AchievementsEvent extends Equatable {
  const AchievementsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadAchievements extends AchievementsEvent {
  const LoadAchievements();
}

class RefreshAchievements extends AchievementsEvent {
  const RefreshAchievements();
}

class UpdateAchievementProgress extends AchievementsEvent {
  const UpdateAchievementProgress({
    required this.type,
    required this.increment,
  });

  final AchievementType type;
  final int increment;

  @override
  List<Object?> get props => <Object?>[type, increment];
}

class CheckAndUnlockAchievements extends AchievementsEvent {
  const CheckAndUnlockAchievements();
}

class ClearAchievementNotifications extends AchievementsEvent {
  const ClearAchievementNotifications();
}
