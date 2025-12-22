part of 'habits_list_bloc.dart';

@immutable
sealed  class HabitsListEvent extends Equatable {
  const HabitsListEvent();

  @override
  List<Object?> get props => [];
}

class LoadHabitsForDate extends HabitsListEvent {
  const LoadHabitsForDate(this.date);
  final DateTime date;

  @override
  List<Object?> get props => [date];
}

class UpdateHabitLogStatus extends HabitsListEvent {
  const UpdateHabitLogStatus({
    required this.log,
    required this.status,
    this.completedValue,
  });

  final HabitLogEntity log;
  final LogStatus status;
  final int? completedValue;

  @override
  List<Object?> get props => [log, status, completedValue];
}

class RefreshHabits extends HabitsListEvent {
  const RefreshHabits();
}
