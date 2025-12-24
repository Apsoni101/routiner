part of 'custom_habit_bloc.dart';

abstract class CreateCustomHabitEvent extends Equatable {
  const CreateCustomHabitEvent();

  @override
  List<Object?> get props => [];
}

class NameChanged extends CreateCustomHabitEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class IconSelected extends CreateCustomHabitEvent {
  const IconSelected(this.icon);

  final IconData icon;

  @override
  List<Object> get props => [icon];
}

class HabitIconSelected extends CreateCustomHabitEvent {
  const HabitIconSelected(this.habit);

  final Habit habit;

  @override
  List<Object> get props => [habit];
}

class ColorSelected extends CreateCustomHabitEvent {
  const ColorSelected(this.color);

  final Color color;

  @override
  List<Object> get props => [color];
}

class GoalValueChanged extends CreateCustomHabitEvent {
  const GoalValueChanged(this.goalValue);

  final GoalValue goalValue;

  @override
  List<Object> get props => [goalValue];
}

class ReminderAdded extends CreateCustomHabitEvent {
  const ReminderAdded(this.reminder);

  final TimeOfDay reminder;

  @override
  List<Object> get props => [reminder];
}

class ReminderRemoved extends CreateCustomHabitEvent {
  const ReminderRemoved(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

class TypeSelected extends CreateCustomHabitEvent {
  const TypeSelected(this.type);

  final HabitType type;

  @override
  List<Object> get props => [type];
}

class LocationChanged extends CreateCustomHabitEvent {
  const LocationChanged(this.location);

  final String location;

  @override
  List<Object> get props => [location];
}

class GoalFrequencyChanged extends CreateCustomHabitEvent {
  const GoalFrequencyChanged(this.frequency);

  final RepeatInterval frequency;

  @override
  List<Object> get props => [frequency];
}

class GoalDaysChanged extends CreateCustomHabitEvent {
  const GoalDaysChanged(this.days);

  final List<Day> days;

  @override
  List<Object> get props => [days];
}

class SaveHabitPressed extends CreateCustomHabitEvent {
  const SaveHabitPressed({this.isAlarmEnabled, this.alarmTime, this.alarmDays});

  final bool? isAlarmEnabled;
  final TimeOfDay? alarmTime;
  final List<Day>? alarmDays;

  @override
  List<Object?> get props => [isAlarmEnabled, alarmTime, alarmDays];
}

// ✨ NEW EVENTS FOR LOADING DATA ✨

class LoadActivities extends CreateCustomHabitEvent {
  const LoadActivities({
    this.limit,
    this.forceRefresh = false,
    this.syncFromRemote = true,
  });

  final int? limit;
  final bool forceRefresh;
  final bool syncFromRemote;

  @override
  List<Object?> get props => [limit, forceRefresh, syncFromRemote];
}

class LoadTotalPoints extends CreateCustomHabitEvent {
  const LoadTotalPoints({
    this.forceRefresh = false,
    this.syncFromRemote = true,
  });

  final bool forceRefresh;
  final bool syncFromRemote;

  @override
  List<Object?> get props => [forceRefresh, syncFromRemote];
}
