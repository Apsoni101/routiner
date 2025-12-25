part of 'achievement_bloc.dart';

@immutable
sealed class AchievementsState extends Equatable {
  const AchievementsState();

  @override
  List<Object?> get props => <Object?>[];
}

class AchievementsInitial extends AchievementsState {
  const AchievementsInitial();
}

class AchievementsLoading extends AchievementsState {
  const AchievementsLoading();
}

class AchievementsLoaded extends AchievementsState {
  const AchievementsLoaded({
    required this.achievements,
    this.newlyUnlocked = const <AchievementEntity>[],
  });

  final List<AchievementEntity> achievements;
  final List<AchievementEntity> newlyUnlocked;

  AchievementsLoaded copyWith({
    final List<AchievementEntity>? achievements,
    final List<AchievementEntity>? newlyUnlocked,
  }) {
    return AchievementsLoaded(
      achievements: achievements ?? this.achievements,
      newlyUnlocked: newlyUnlocked ?? this.newlyUnlocked,
    );
  }

  @override
  List<Object?> get props => <Object?>[achievements, newlyUnlocked];
}

class AchievementsError extends AchievementsState {
  const AchievementsError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
