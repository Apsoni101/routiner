part of 'daily_activity_bloc.dart';

abstract class DailyActivityEvent extends Equatable {
  const DailyActivityEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class DailyActivityDateChanged extends DailyActivityEvent {
  const DailyActivityDateChanged(this.date);

  final DateTime date;

  @override
  List<Object?> get props => <Object?>[date];
}

class DailyActivitySummaryRequested extends DailyActivityEvent {
  const DailyActivitySummaryRequested();
}
