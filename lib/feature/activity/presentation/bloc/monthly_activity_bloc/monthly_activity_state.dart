// Add this to your monthly_activity_state.dart file

part of 'monthly_activity_bloc.dart';
// part of 'monthly_activity_bloc.dart';

class MonthlyActivityState extends Equatable {
  const MonthlyActivityState({
    this.month,
    this.year,
    this.summary,
    this.chartData = const [],
    this.moodChartData = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final int? month;
  final int? year;
  final ActivitySummaryEntity? summary;
  final List<ChartDataPoint> chartData;
  final List<MoodChartDataPoint> moodChartData;
  final bool isLoading;
  final String? errorMessage;

  MonthlyActivityState copyWith({
    int? month,
    int? year,
    ActivitySummaryEntity? summary,
    List<ChartDataPoint>? chartData,
    List<MoodChartDataPoint>? moodChartData,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MonthlyActivityState(
      month: month ?? this.month,
      year: year ?? this.year,
      summary: summary ?? this.summary,
      chartData: chartData ?? this.chartData,
      moodChartData: moodChartData ?? this.moodChartData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    month,
    year,
    summary,
    chartData,
    moodChartData,
    isLoading,
    errorMessage,
  ];
}