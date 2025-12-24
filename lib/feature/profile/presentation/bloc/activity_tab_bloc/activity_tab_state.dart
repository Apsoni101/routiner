part of 'activity_tab_bloc.dart';

@immutable
sealed class ActivityTabState extends Equatable {
  const ActivityTabState();

  @override
  List<Object?> get props => [];
}

class ActivityTabInitial extends ActivityTabState {}

class ActivityTabLoading extends ActivityTabState {}

class ActivityTabLoaded extends ActivityTabState {
  const ActivityTabLoaded({
    required this.activities,
    required this.totalPoints,
    this.errorMessage,
  });

  final List<ActivityEntity> activities;
  final int totalPoints;
  final String? errorMessage;

  @override
  List<Object?> get props => [activities, totalPoints, errorMessage];

  ActivityTabLoaded copyWith({
    List<ActivityEntity>? activities,
    int? totalPoints,
    String? errorMessage,
  }) {
    return ActivityTabLoaded(
      activities: activities ?? this.activities,
      totalPoints: totalPoints ?? this.totalPoints,
      errorMessage: errorMessage,
    );
  }
}

class ActivityTabError extends ActivityTabState {
  const ActivityTabError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
