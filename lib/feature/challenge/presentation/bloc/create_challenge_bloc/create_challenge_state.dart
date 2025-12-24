part of 'create_challenge_bloc.dart';

@immutable
class CreateChallengeState extends Equatable {
  const CreateChallengeState({
    this.title = '',
    this.description = '',
    this.emoji = Emoji.grinningFace,
    this.duration = 30,
    this.durationType = ChallengeDurationType.days,
    this.selectedHabits = const [],
    this.availableHabits = const [],
    this.isLoadingHabits = false,
    this.isCreating = false,
    this.isSuccess = false,
    this.errorMessage,
    this.createdChallengeId,
  });

  final String title;
  final String description;
  final Emoji emoji;
  final int duration;
  final ChallengeDurationType durationType;
  final List<CustomHabitEntity> selectedHabits;
  final List<CustomHabitEntity> availableHabits;
  final bool isLoadingHabits;
  final bool isCreating;
  final bool isSuccess;
  final String? errorMessage;
  final String? createdChallengeId;

  bool get isValid =>
      title.trim().isNotEmpty &&
          description.trim().isNotEmpty &&
          duration > 0 &&
          selectedHabits.isNotEmpty;

  CreateChallengeState copyWith({
    String? title,
    String? description,
    Emoji? emoji,
    int? duration,
    ChallengeDurationType? durationType,
    List<CustomHabitEntity>? selectedHabits,
    List<CustomHabitEntity>? availableHabits,
    bool? isLoadingHabits,
    bool? isCreating,
    bool? isSuccess,
    String? errorMessage,
    String? createdChallengeId,
  }) {
    return CreateChallengeState(
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      duration: duration ?? this.duration,
      durationType: durationType ?? this.durationType,
      selectedHabits: selectedHabits ?? this.selectedHabits,
      availableHabits: availableHabits ?? this.availableHabits,
      isLoadingHabits: isLoadingHabits ?? this.isLoadingHabits,
      isCreating: isCreating ?? this.isCreating,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      createdChallengeId: createdChallengeId ?? this.createdChallengeId,
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    emoji,
    duration,
    durationType,
    selectedHabits,
    availableHabits,
    isLoadingHabits,
    isCreating,
    isSuccess,
    errorMessage,
    createdChallengeId,
  ];
}

class CreateChallengeInitial extends CreateChallengeState {
  const CreateChallengeInitial();
}