part of 'custom_habit_bloc.dart';

class CreateCustomHabitState extends Equatable {
  const CreateCustomHabitState({
    this.name = '',
    this.selectedIcon,
    this.selectedHabit = Habit.journal, 
    this.selectedColor = const Color(0xFF3843FF), 
    this.goal = '',
    this.reminders = const [],
    this.selectedType,
    this.location = '',
    this.isValid = false,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage,
    this.goalValue = 1,
    this.goalUnit = GoalUnit.times, 
    this.goalFrequency = RepeatInterval.daily, 
    this.goalDays = const [], 
    this.pointsEarned,
    this.totalPoints,
    this.activities,
    this.isLoadingActivities = false,
    this.isLoadingPoints = false,
  });

  
  final String name;
  final IconData? selectedIcon;
  final Habit? selectedHabit; 
  final Color selectedColor; 
  final String goal;
  final List<TimeOfDay> reminders;
  final HabitType? selectedType;
  final String location;
  final bool isValid;
  final bool isLoading;
  final bool isSaved;
  final String? errorMessage;
  final int goalValue;
  final GoalUnit goalUnit; 
  final RepeatInterval goalFrequency; 
  final List<Day> goalDays; 

  
  final int? pointsEarned;
  final int? totalPoints;
  final List<ActivityEntity>? activities;
  final bool isLoadingActivities;
  final bool isLoadingPoints;

  @override
  List<Object?> get props => [
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
    isSaved,
    errorMessage,
    goalValue,
    goalUnit,
    goalFrequency,
    goalDays,
    pointsEarned,
    totalPoints,
    activities,
    isLoadingActivities,
    isLoadingPoints,
  ];

  CreateCustomHabitState copyWith({
    String? name,
    IconData? selectedIcon,
    Habit? selectedHabit,
    Color? selectedColor,
    String? goal,
    List<TimeOfDay>? reminders,
    HabitType? selectedType,
    String? location,
    bool? isValid,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
    bool clearIcon = false,
    bool clearHabit = false,
    int? goalValue,
    GoalUnit? goalUnit,
    RepeatInterval? goalFrequency,
    List<Day>? goalDays,
    int? pointsEarned,
    int? totalPoints,
    List<ActivityEntity>? activities,
    bool? isLoadingActivities,
    bool? isLoadingPoints,
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
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
      goalValue: goalValue ?? this.goalValue,
      goalUnit: goalUnit ?? this.goalUnit,
      goalFrequency: goalFrequency ?? this.goalFrequency,
      goalDays: goalDays ?? this.goalDays,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      totalPoints: totalPoints ?? this.totalPoints,
      activities: activities ?? this.activities,
      isLoadingActivities: isLoadingActivities ?? this.isLoadingActivities,
      isLoadingPoints: isLoadingPoints ?? this.isLoadingPoints,
    );
  }
}
