part of 'custom_habit_bloc.dart';

@immutable
sealed class CreateCustomHabitEvent extends Equatable {
  const CreateCustomHabitEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class NameChanged extends CreateCustomHabitEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => <Object?>[name];
}

class IconSelected extends CreateCustomHabitEvent {
  const IconSelected(this.icon);

  final IconData icon;

  @override
  List<Object?> get props => <Object?>[icon];
}

class HabitIconSelected extends CreateCustomHabitEvent {
  const HabitIconSelected(this.habit);

  final Habit habit;

  @override
  List<Object?> get props => <Object?>[habit];
}

class ColorSelected extends CreateCustomHabitEvent {
  const ColorSelected(this.color);

  final Color color;

  @override
  List<Object?> get props => <Object?>[color];
}

class GoalValueChanged extends CreateCustomHabitEvent {
  const GoalValueChanged(this.goalValue);

  final GoalValue goalValue;

  @override
  List<Object?> get props => <Object?>[goalValue];
}

class ReminderAdded extends CreateCustomHabitEvent {
  const ReminderAdded(this.reminder);

  final TimeOfDay reminder;

  @override
  List<Object?> get props => <Object?>[reminder];
}

class ReminderRemoved extends CreateCustomHabitEvent {
  const ReminderRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => <Object?>[index];
}

class TypeSelected extends CreateCustomHabitEvent {
  const TypeSelected(this.type);

  final HabitType type;

  @override
  List<Object?> get props => <Object?>[type];
}

class LocationChanged extends CreateCustomHabitEvent {
  const LocationChanged(this.location);

  final String? location;

  @override
  List<Object?> get props => <Object?>[location];
}

class GoalFrequencyChanged extends CreateCustomHabitEvent {
  const GoalFrequencyChanged(this.frequency);

  final RepeatInterval frequency;

  @override
  List<Object?> get props => <Object?>[frequency];
}

class GoalDaysChanged extends CreateCustomHabitEvent {
  const GoalDaysChanged(this.days);

  final List<Day> days;

  @override
  List<Object> get props => <Object>[days];
}

class SaveHabitPressed extends CreateCustomHabitEvent {
  const SaveHabitPressed({
    this.isAlarmEnabled = false,
    this.alarmTime,
    this.alarmDays = const <Day>[],
  });

  final bool isAlarmEnabled;
  final TimeOfDay? alarmTime;
  final List<Day> alarmDays;

  @override
  List<Object?> get props => <Object?>[isAlarmEnabled, alarmTime, alarmDays];
}
