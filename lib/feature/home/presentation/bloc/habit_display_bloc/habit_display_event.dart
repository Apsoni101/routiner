part of 'habit_display_bloc.dart';

@immutable
sealed class HabitDisplayEvent extends Equatable {
  const HabitDisplayEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadHabitsForDate extends HabitDisplayEvent {
  const LoadHabitsForDate(this.date);

  final DateTime date;

  @override
  List<Object?> get props => <Object?>[date];
}

class UpdateHabitLogStatus extends HabitDisplayEvent {
  const UpdateHabitLogStatus({
    required this.log,
    required this.status,
    this.completedValue,
  });

  final HabitLogEntity log;
  final LogStatus status;
  final int? completedValue;

  @override
  List<Object?> get props => <Object?>[log, status, completedValue];
}

class RefreshHabits extends HabitDisplayEvent {
  const RefreshHabits();
}

class LoadChallenges extends HabitDisplayEvent {
  const LoadChallenges();
}
