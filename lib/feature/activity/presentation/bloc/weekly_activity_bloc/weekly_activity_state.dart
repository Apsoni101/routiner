part of 'weekly_activity_bloc.dart';
// part of 'weekly_activity_bloc.dart';

class WeeklyActivityState extends Equatable {
  const WeeklyActivityState({
    this.startDate,
    this.endDate,
    this.summary,
    this.chartData = const [],
    this.moodChartData = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final ActivitySummaryEntity? summary;
  final List<ChartDataPoint> chartData;
  final List<MoodChartDataPoint> moodChartData;
  final bool isLoading;
  final String? errorMessage;

  WeeklyActivityState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    ActivitySummaryEntity? summary,
    List<ChartDataPoint>? chartData,
    List<MoodChartDataPoint>? moodChartData,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WeeklyActivityState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      summary: summary ?? this.summary,
      chartData: chartData ?? this.chartData,
      moodChartData: moodChartData ?? this.moodChartData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    summary,
    chartData,
    moodChartData,
    isLoading,
    errorMessage,
  ];
}