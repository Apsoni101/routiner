part of 'monthly_activity_bloc.dart';

abstract class MonthlyActivityEvent extends Equatable {
  const MonthlyActivityEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class MonthlyActivityMonthChanged extends MonthlyActivityEvent {
  const MonthlyActivityMonthChanged({required this.month, required this.year});

  final int month;
  final int year;

  @override
  List<Object?> get props => <Object?>[month, year];
}

class MonthlyActivitySummaryRequested extends MonthlyActivityEvent {
  const MonthlyActivitySummaryRequested();
}
