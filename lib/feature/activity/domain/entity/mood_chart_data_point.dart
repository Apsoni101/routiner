import 'package:equatable/equatable.dart';
import 'package:routiner/core/enums/moods.dart';

class MoodChartDataPoint extends Equatable {
  const MoodChartDataPoint({
    required this.label,
    required this.dateTime,
    required this.mood,
    this.isToday = false,
  });

  final String label;
  final DateTime dateTime;
  final Mood? mood;
  final bool isToday;

  @override
  List<Object?> get props => [label, dateTime, mood, isToday];
}