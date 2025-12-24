// Add this to your daily_activity_state.dart file

part of 'daily_activity_bloc.dart';
// part of 'daily_activity_bloc.dart';

class DailyActivityState extends Equatable {
  const DailyActivityState({
    required this.currentDate,
    this.summary,
    this.chartData = const [],
    this.moodChartData = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final DateTime currentDate;
  final ActivitySummaryEntity? summary;
  final List<ChartDataPoint> chartData;
  final List<MoodChartDataPoint> moodChartData;
  final bool isLoading;
  final String? errorMessage;

  DailyActivityState copyWith({
    DateTime? currentDate,
    ActivitySummaryEntity? summary,
    List<ChartDataPoint>? chartData,
    List<MoodChartDataPoint>? moodChartData,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DailyActivityState(
      currentDate: currentDate ?? this.currentDate,
      summary: summary ?? this.summary,
      chartData: chartData ?? this.chartData,
      moodChartData: moodChartData ?? this.moodChartData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    currentDate,
    summary,
    chartData,
    moodChartData,
    isLoading,
    errorMessage,
  ];
}