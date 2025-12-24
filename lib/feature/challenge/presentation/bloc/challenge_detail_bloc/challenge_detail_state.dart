part of 'challenge_detail_bloc.dart';

abstract class ChallengeDetailState extends Equatable {
  const ChallengeDetailState();

  @override
  List<Object?> get props => [];
}

class ChallengeDetailInitial extends ChallengeDetailState {}

class ChallengeDetailLoading extends ChallengeDetailState {}

class ChallengeDetailLoaded extends ChallengeDetailState {
  const ChallengeDetailLoaded({
    required this.challenge,
    required this.habits,
    required this.friendsCount,
    required this.habitsWithLogs,
    required this.habitFriendsCountMap,
    this.currentUserId,
    this.errorMessage,
  });

  final ChallengeEntity challenge;
  final List<CustomHabitEntity> habits;
  final int friendsCount;
  final String? currentUserId;
  final List<HabitWithLog> habitsWithLogs;
  final Map<String, int> habitFriendsCountMap;
  final String? errorMessage;

  @override
  List<Object?> get props => [
    challenge,
    habits,
    friendsCount,
    currentUserId,
    habitsWithLogs,
    habitFriendsCountMap,
    errorMessage,
  ];

  // ADD THIS METHOD if it doesn't exist
  ChallengeDetailLoaded copyWith({
    ChallengeEntity? challenge,
    List<CustomHabitEntity>? habits,
    int? friendsCount,
    String? currentUserId,
    List<HabitWithLog>? habitsWithLogs,
    Map<String, int>? habitFriendsCountMap,
    String? errorMessage,
  }) {
    return ChallengeDetailLoaded(
      challenge: challenge ?? this.challenge,
      habits: habits ?? this.habits,
      friendsCount: friendsCount ?? this.friendsCount,
      currentUserId: currentUserId ?? this.currentUserId,
      habitsWithLogs: habitsWithLogs ?? this.habitsWithLogs,
      habitFriendsCountMap: habitFriendsCountMap ?? this.habitFriendsCountMap,
      errorMessage: errorMessage,
    );
  }
}

class ChallengeDetailError extends ChallengeDetailState {
  const ChallengeDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}