part of 'weekly_activity_bloc.dart';

abstract class WeeklyActivityEvent extends Equatable {
  const WeeklyActivityEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class WeeklyActivityWeekChanged extends WeeklyActivityEvent {
  const WeeklyActivityWeekChanged({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => <Object?>[startDate, endDate];
}

class WeeklyActivitySummaryRequested extends WeeklyActivityEvent {
  const WeeklyActivitySummaryRequested();
}
