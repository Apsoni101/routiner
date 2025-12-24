part of 'activity_tab_bloc.dart';

@immutable
sealed  class ActivityTabEvent extends Equatable {
  const ActivityTabEvent();

  @override
  List<Object?> get props => [];
}

class LoadActivities extends ActivityTabEvent {
  const LoadActivities({
    this.limit,
    this.forceRefresh = false,
    this.syncFromRemote = true,
  });

  final int? limit;
  final bool forceRefresh;
  final bool syncFromRemote;

  @override
  List<Object?> get props => [limit, forceRefresh, syncFromRemote];
}

class RefreshActivities extends ActivityTabEvent {
  const RefreshActivities({this.limit});

  final int? limit;

  @override
  List<Object?> get props => [limit];
}
