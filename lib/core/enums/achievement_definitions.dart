import 'package:routiner/core/enums/achievement_type.dart';
import 'package:routiner/feature/profile/domain/entity/achievement_entity.dart';

enum AchievementDefinition {
  // Habit Streak Achievements
  streakBronze(
    id: 'streak_bronze',
    title: 'Getting Started',
    description: 'Complete a habit for 3 days in a row',
    type: AchievementType.habitStreak,
    tier: AchievementTier.bronze,
    targetValue: 3,
    pointsReward: 50,
    iconPath: '🔥',
  ),
  streakSilver(
    id: 'streak_silver',
    title: 'Week Warrior',
    description: 'Complete a habit for 7 days in a row',
    type: AchievementType.habitStreak,
    tier: AchievementTier.silver,
    targetValue: 7,
    pointsReward: 100,
    iconPath: '🔥',
  ),
  streakGold(
    id: 'streak_gold',
    title: 'Dedicated',
    description: 'Complete a habit for 30 days in a row',
    type: AchievementType.habitStreak,
    tier: AchievementTier.gold,
    targetValue: 30,
    pointsReward: 500,
    iconPath: '🔥',
  ),
  streakPlatinum(
    id: 'streak_platinum',
    title: 'Unstoppable',
    description: 'Complete a habit for 100 days in a row',
    type: AchievementType.habitStreak,
    tier: AchievementTier.platinum,
    targetValue: 100,
    pointsReward: 2000,
    iconPath: '🔥',
  ),

  // Points Milestone Achievements
  pointsBronze(
    id: 'points_bronze',
    title: 'First Steps',
    description: 'Earn 100 total points',
    type: AchievementType.pointsMilestone,
    tier: AchievementTier.bronze,
    targetValue: 100,
    pointsReward: 20,
    iconPath: '⭐',
  ),
  pointsSilver(
    id: 'points_silver',
    title: 'Rising Star',
    description: 'Earn 500 total points',
    type: AchievementType.pointsMilestone,
    tier: AchievementTier.silver,
    targetValue: 500,
    pointsReward: 100,
    iconPath: '⭐',
  ),
  pointsGold(
    id: 'points_gold',
    title: 'Point Master',
    description: 'Earn 2000 total points',
    type: AchievementType.pointsMilestone,
    tier: AchievementTier.gold,
    targetValue: 2000,
    pointsReward: 300,
    iconPath: '⭐',
  ),
  pointsPlatinum(
    id: 'points_platinum',
    title: 'Legend',
    description: 'Earn 10000 total points',
    type: AchievementType.pointsMilestone,
    tier: AchievementTier.platinum,
    targetValue: 10000,
    pointsReward: 1000,
    iconPath: '⭐',
  ),

  // Total Habits Achievements
  habitsBronze(
    id: 'habits_bronze',
    title: 'Habit Beginner',
    description: 'Create 3 custom habits',
    type: AchievementType.totalHabits,
    tier: AchievementTier.bronze,
    targetValue: 3,
    pointsReward: 30,
    iconPath: '📝',
  ),
  habitsSilver(
    id: 'habits_silver',
    title: 'Habit Builder',
    description: 'Create 10 custom habits',
    type: AchievementType.totalHabits,
    tier: AchievementTier.silver,
    targetValue: 10,
    pointsReward: 150,
    iconPath: '📝',
  ),
  habitsGold(
    id: 'habits_gold',
    title: 'Habit Architect',
    description: 'Create 25 custom habits',
    type: AchievementType.totalHabits,
    tier: AchievementTier.gold,
    targetValue: 25,
    pointsReward: 400,
    iconPath: '📝',
  ),

  // Consistency Achievements
  consistencyBronze(
    id: 'consistency_bronze',
    title: 'Consistent Start',
    description: 'Log habits for 5 consecutive days',
    type: AchievementType.consistency,
    tier: AchievementTier.bronze,
    targetValue: 5,
    pointsReward: 75,
    iconPath: '📅',
  ),
  consistencySilver(
    id: 'consistency_silver',
    title: 'Consistency King',
    description: 'Log habits for 14 consecutive days',
    type: AchievementType.consistency,
    tier: AchievementTier.silver,
    targetValue: 14,
    pointsReward: 200,
    iconPath: '📅',
  ),
  consistencyGold(
    id: 'consistency_gold',
    title: 'Never Miss',
    description: 'Log habits for 30 consecutive days',
    type: AchievementType.consistency,
    tier: AchievementTier.gold,
    targetValue: 30,
    pointsReward: 600,
    iconPath: '📅',
  ),

  // Early Bird Achievement
  earlyBird(
    id: 'early_bird',
    title: 'Early Bird',
    description: 'Complete 10 habits before 9 AM',
    type: AchievementType.earlyBird,
    tier: AchievementTier.silver,
    targetValue: 10,
    pointsReward: 150,
    iconPath: '🌅',
  ),

  // Perfect Week Achievement
  perfectWeek(
    id: 'perfect_week',
    title: 'Perfect Week',
    description: 'Complete all your habits for 7 consecutive days',
    type: AchievementType.perfectWeek,
    tier: AchievementTier.gold,
    targetValue: 1,
    pointsReward: 500,
    iconPath: '🏆',
  ),

  // Challenge Achievements
  challengeBronze(
    id: 'challenge_bronze',
    title: 'Challenger',
    description: 'Win your first challenge',
    type: AchievementType.challengeWin,
    tier: AchievementTier.bronze,
    targetValue: 1,
    pointsReward: 100,
    iconPath: '🎯',
  ),
  challengeSilver(
    id: 'challenge_silver',
    title: 'Champion',
    description: 'Win 5 challenges',
    type: AchievementType.challengeWin,
    tier: AchievementTier.silver,
    targetValue: 5,
    pointsReward: 300,
    iconPath: '🎯',
  ),
  challengeGold(
    id: 'challenge_gold',
    title: 'Grand Champion',
    description: 'Win 20 challenges',
    type: AchievementType.challengeWin,
    tier: AchievementTier.gold,
    targetValue: 20,
    pointsReward: 1000,
    iconPath: '🎯',
  ),

  // Social Achievements
  socialBronze(
    id: 'social_bronze',
    title: 'Social Starter',
    description: 'Join 1 challenge with friends',
    type: AchievementType.socialButterfly,
    tier: AchievementTier.bronze,
    targetValue: 1,
    pointsReward: 50,
    iconPath: '👥',
  ),
  socialSilver(
    id: 'social_silver',
    title: 'Team Player',
    description: 'Join 5 challenges with friends',
    type: AchievementType.socialButterfly,
    tier: AchievementTier.silver,
    targetValue: 5,
    pointsReward: 200,
    iconPath: '👥',
  );

  const AchievementDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.tier,
    required this.targetValue,
    required this.pointsReward,
    required this.iconPath,
  });

  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final AchievementTier tier;
  final int targetValue;
  final int pointsReward;
  final String iconPath;

  // Convert enum to entity
  AchievementEntity toEntity({
    int currentProgress = 0,
    bool isUnlocked = false,
    DateTime? unlockedAt,
  }) {
    return AchievementEntity(
      id: id,
      title: title,
      description: description,
      type: type,
      tier: tier,
      targetValue: targetValue,
      currentProgress: currentProgress,
      isUnlocked: isUnlocked,
      unlockedAt: unlockedAt,
      pointsReward: pointsReward,
      iconPath: iconPath,
    );
  }

  // Get all achievements as entities
  static List<AchievementEntity> getAllAsEntities() {
    return AchievementDefinition.values.map((def) => def.toEntity()).toList();
  }
}
