part of 'habits_list_bloc.dart';

@immutable
sealed class HabitsListState extends Equatable {
  const HabitsListState();

  @override
  List<Object?> get props => <Object?>[];
}

class HabitsListInitial extends HabitsListState {}

class HabitsListLoading extends HabitsListState {}

class HabitsListLoaded extends HabitsListState {
  const HabitsListLoaded({
    required this.habitsWithLogs,
    required this.selectedDate,
    required this.friendsCountMap,
    this.errorMessage,
    this.pointsEarned, // ✨ NEW FIELD
    this.totalPoints,   // ✨ NEW FIELD
  });

  final List<HabitWithLog> habitsWithLogs;
  final DateTime selectedDate;
  final Map<String, int> friendsCountMap;
  final String? errorMessage;
  final int? pointsEarned;    // ✨ Points earned in this action
  final int? totalPoints;     // ✨ User's total points

  @override
  List<Object?> get props => [
    habitsWithLogs,
    selectedDate,
    friendsCountMap,
    errorMessage,
    pointsEarned,
    totalPoints,
  ];

  HabitsListLoaded copyWith({
    List<HabitWithLog>? habitsWithLogs,
    DateTime? selectedDate,
    Map<String, int>? friendsCountMap,
    String? errorMessage,
    int? pointsEarned,
    int? totalPoints,
  }) {
    return HabitsListLoaded(
      habitsWithLogs: habitsWithLogs ?? this.habitsWithLogs,
      selectedDate: selectedDate ?? this.selectedDate,
      friendsCountMap: friendsCountMap ?? this.friendsCountMap,
      errorMessage: errorMessage,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }
}
class HabitsListError extends HabitsListState {
  const HabitsListError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
