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
  });

  final List<HabitWithLog> habitsWithLogs;
  final DateTime selectedDate;
  final Map<String, int> friendsCountMap;


  @override
  List<Object?> get props => <Object?>[habitsWithLogs, selectedDate,friendsCountMap];
}

class HabitDisplayError extends HabitDisplayState {
  const HabitDisplayError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
