part of 'custom_habit_bloc.dart';

class CreateCustomHabitState extends Equatable {
  const CreateCustomHabitState({
    this.name = '',
    this.selectedIcon = Icons.star,
    this.selectedHabit,
    this.selectedColor = Colors.blue,
    this.goal,
    this.reminders = const <TimeOfDay>[],
    this.selectedType = HabitType.daily,
    this.location,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
    this.isSaved = false,
    this.goalValue = 1,
    this.goalUnit = GoalUnit.times,
    this.goalFrequency = RepeatInterval.daily,
    this.goalDays = const <Day>[],
  });

  final String name;
  final IconData? selectedIcon;
  final Habit? selectedHabit;
  final Color selectedColor;
  final String? goal;
  final List<TimeOfDay> reminders;
  final HabitType selectedType;
  final String? location;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;
  final bool isSaved;
  final int goalValue;
  final GoalUnit goalUnit;
  final RepeatInterval goalFrequency;
  final List<Day> goalDays;

  CreateCustomHabitState copyWith({
    final String? name,
    final IconData? selectedIcon,
    final Habit? selectedHabit,
    final bool clearIcon = false,
    final bool clearHabit = false,
    final Color? selectedColor,
    final String? goal,
    final List<TimeOfDay>? reminders,
    final HabitType? selectedType,
    final String? location,
    final bool? isValid,
    final bool? isLoading,
    final String? errorMessage,
    final bool? isSaved,
    final int? goalValue,
    final GoalUnit? goalUnit,
    final RepeatInterval? goalFrequency,
    final List<Day>? goalDays,
  }) {
    return CreateCustomHabitState(
      name: name ?? this.name,
      selectedIcon: clearIcon ? null : (selectedIcon ?? this.selectedIcon),
      selectedHabit: clearHabit ? null : (selectedHabit ?? this.selectedHabit),
      selectedColor: selectedColor ?? this.selectedColor,
      goal: goal ?? this.goal,
      reminders: reminders ?? this.reminders,
      selectedType: selectedType ?? this.selectedType,
      location: location ?? this.location,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSaved: isSaved ?? this.isSaved,
      goalValue: goalValue ?? this.goalValue,
      goalUnit: goalUnit ?? this.goalUnit,
      goalFrequency: goalFrequency ?? this.goalFrequency,
      goalDays: goalDays ?? this.goalDays,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    name,
    selectedIcon,
    selectedHabit,
    selectedColor,
    goal,
    reminders,
    selectedType,
    location,
    isValid,
    isLoading,
    errorMessage,
    isSaved,
    goalValue,
    goalUnit,
    goalFrequency,
    goalDays,
  ];
}
