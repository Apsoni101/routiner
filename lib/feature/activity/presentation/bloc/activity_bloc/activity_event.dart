part of 'activity_bloc.dart';

@immutable
sealed class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class ActivityInitialized extends ActivityEvent {
  const ActivityInitialized();
}

class ActivityTabChanged extends ActivityEvent {
  const ActivityTabChanged(this.tabIndex);

  final int tabIndex;

  @override
  List<Object?> get props => <Object?>[tabIndex];
}

class ActivityDateNavigated extends ActivityEvent {
  const ActivityDateNavigated(this.isNext);

  final bool isNext;

  @override
  List<Object?> get props => <Object?>[isNext];
}
