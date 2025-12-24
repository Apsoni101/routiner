part of 'activity_bloc.dart';

class ActivityState extends Equatable {
  const ActivityState({
    required this.selectedTabIndex,
    required this.currentDate,
  });

  factory ActivityState.initial() {
    return ActivityState(selectedTabIndex: 0, currentDate: DateTime.now());
  }

  final int selectedTabIndex;
  final DateTime currentDate;

  ActivityState copyWith({
    final int? selectedTabIndex,
    final DateTime? currentDate,
  }) {
    return ActivityState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      currentDate: currentDate ?? this.currentDate,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedTabIndex, currentDate];
}
