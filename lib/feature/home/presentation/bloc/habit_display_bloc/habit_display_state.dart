part of 'habit_display_bloc.dart';

@immutable
sealed class HabitDisplayState extends Equatable {
  const HabitDisplayState();

  @override
  List<Object?> get props => <Object?>[];
}

class HabitDisplayInitial extends HabitDisplayState {}

class HabitDisplayLoading extends HabitDisplayState {}

class HabitDisplayLoaded extends HabitDisplayState {
  const HabitDisplayLoaded({
    required this.habitsWithLogs,
    required this.selectedDate,
    this.friendsCountMap = const <String, int>{},
    this.challenges = const <ChallengeEntity>[],
    this.challengesLoading = false,
    this.errorMessage,
    this.pointsEarned,
    this.totalPoints,
  });

  final List<HabitWithLog> habitsWithLogs;
  final DateTime selectedDate;
  final Map<String, int> friendsCountMap;
  final List<ChallengeEntity> challenges;
  final bool challengesLoading;
  final String? errorMessage;
  final int? pointsEarned;
  final int? totalPoints;

  HabitDisplayLoaded copyWith({
    final List<HabitWithLog>? habitsWithLogs,
    final DateTime? selectedDate,
    final Map<String, int>? friendsCountMap,
    final List<ChallengeEntity>? challenges,
    final bool? challengesLoading,
    final String? errorMessage,
    final int? pointsEarned,
    final int? totalPoints,
  }) {
    return HabitDisplayLoaded(
      habitsWithLogs: habitsWithLogs ?? this.habitsWithLogs,
      selectedDate: selectedDate ?? this.selectedDate,
      friendsCountMap: friendsCountMap ?? this.friendsCountMap,
      challenges: challenges ?? this.challenges,
      challengesLoading: challengesLoading ?? this.challengesLoading,
      errorMessage: errorMessage,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    habitsWithLogs,
    selectedDate,
    friendsCountMap,
    challenges,
    challengesLoading,
    errorMessage,
    pointsEarned,
    totalPoints,
  ];
}

class HabitDisplayError extends HabitDisplayState {
  const HabitDisplayError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
