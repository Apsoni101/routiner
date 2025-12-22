part of 'habits_list_bloc.dart';

@immutable
sealed class HabitsListState extends Equatable {
  const HabitsListState();

  @override
  List<Object?> get props => <Object?>[];
}

class HabitsListInitial extends HabitsListState {}

class HabitsListLoading extends HabitsListState {}

final class HabitsListLoaded extends HabitsListState {
  const HabitsListLoaded({
    required this.habitsWithLogs,
    required this.selectedDate,
    this.friendsCountMap = const <String, int>{},
  });

  final List<HabitWithLog> habitsWithLogs;
  final DateTime selectedDate;
  final Map<String, int> friendsCountMap;

  @override
  List<Object?> get props => <Object?>[habitsWithLogs, selectedDate, friendsCountMap];
}

class HabitsListError extends HabitsListState {
  const HabitsListError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
