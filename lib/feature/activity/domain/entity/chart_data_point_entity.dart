import 'package:equatable/equatable.dart';

class ChartDataPoint extends Equatable {
  const ChartDataPoint({
    required this.label,
    required this.completedTasks,
    required this.totalTasks,
    this.isToday = false,
  });

  final String label;
  final int completedTasks;
  final int totalTasks;
  final bool isToday;

  ChartDataPoint copyWith({
    final String? label,
    final int? completedTasks,
    final int? totalTasks,
    final bool? isToday,
  }) {
    return ChartDataPoint(
      label: label ?? this.label,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      isToday: isToday ?? this.isToday,
    );
  }

  @override
  List<Object?> get props => [
    label,
    completedTasks,
    totalTasks,
    isToday,
  ];
}
