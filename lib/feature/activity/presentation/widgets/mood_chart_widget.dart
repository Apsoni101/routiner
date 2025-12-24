import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/enums/moods.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/feature/activity/domain/entity/mood_chart_data_point.dart';

class MoodChart extends StatelessWidget {
  const MoodChart({
    required this.chartData,
    required this.timeFrameType,
    super.key,
  });

  final List<MoodChartDataPoint> chartData;
  final TimeFrameType timeFrameType;

  @override
  Widget build(final BuildContext context) {
    final Size mediaSize = MediaQuery.sizeOf(context);

    if (chartData.isEmpty) {
      return SizedBox(
        height: mediaSize.height * 0.16,
        child: const Center(child: Text('No mood data available')),
      );
    }

    final lineBarData = LineChartBarData(
      isCurved: false,
      color: Colors.transparent,
      barWidth: 0,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          final int dataIndex = spot.x.toInt();
          final MoodChartDataPoint point = chartData[dataIndex];

          if (point.mood != null) {
            return FlDotCirclePainter(
              radius: 0,
              color: Colors.transparent,
            );
          }

          return FlDotCirclePainter(
            radius: 4,
            color: Colors.transparent,
            strokeWidth: 0,
          );
        },
      ),
      spots: List<FlSpot>.generate(
        chartData.length,
            (final int index) {
          final MoodChartDataPoint point = chartData[index];
          return FlSpot(
            index.toDouble(),
            point.mood != null ? _moodToYValue(point.mood!) : 2,
          );
        },
      ),
    );

    return SizedBox(
      height: mediaSize.height * 0.16,
      width: mediaSize.width,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (chartData.length - 1).toDouble(),
          minY: 0,
          maxY: 4, // 0-4 for 5 mood levels
          gridData: FlGridData(
            drawVerticalLine: true,
            drawHorizontalLine: true,
            verticalInterval: 1,
            horizontalInterval: 1,
            getDrawingVerticalLine: (final double value) {
              return FlLine(
                color: context.appColors.cEAECF0,
                strokeWidth: 1,
                dashArray: <int>[6, 6],
              );
            },
            getDrawingHorizontalLine: (final double value) {
              return FlLine(
                color: context.appColors.cEAECF0,
                strokeWidth: 1,
                dashArray: <int>[6, 6],
              );
            },
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (final double value, _) {
                  final int index = value.toInt();
                  if (index >= 0 && index < chartData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _getBottomLabel(chartData[index]),
                        style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase
                            .copyWith(color: context.appColors.cCDCDD0),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: <LineChartBarData>[lineBarData],
          lineTouchData: LineTouchData(
            enabled: false,
            touchTooltipData: LineTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(4),
              tooltipMargin: 0,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (final LineBarSpot touchedSpot) {
                return Colors.transparent;
              },
              getTooltipItems: (final List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((final LineBarSpot spot) {
                  final int index = spot.x.toInt();
                  final MoodChartDataPoint data = chartData[index];

                  if (data.mood != null) {
                    return LineTooltipItem(
                      data.mood!.emoji,
                      const TextStyle(fontSize: 20),
                    );
                  }

                  return null;
                }).toList();
              },
            ),
          ),

          showingTooltipIndicators: chartData
              .asMap()
              .entries
              .where((entry) => entry.value.mood != null)
              .map((entry) {
            return ShowingTooltipIndicators([
              LineBarSpot(
                lineBarData,
                0,
                lineBarData.spots[entry.key],
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  String _getBottomLabel(MoodChartDataPoint point) {
    switch (timeFrameType) {
      case TimeFrameType.daily:
      // For daily view, show hour (e.g., "9A", "2P")
        return point.label;
      case TimeFrameType.weekly:
      // For weekly view, show day initial (S, M, T, W, T, F, S)
        return _getDayInitial(point.dateTime);
      case TimeFrameType.monthly:
      // For monthly view, show date
        return point.label;
    }
  }

  String _getDayInitial(DateTime date) {
    const List<String> dayInitials = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return dayInitials[date.weekday % 7];
  }

  double _moodToYValue(Mood mood) {
    switch (mood) {
      case Mood.angry:
        return 0;
      case Mood.sad:
        return 1;
      case Mood.neutral:
        return 2;
      case Mood.happy:
        return 3;
      case Mood.love:
        return 4;
    }
  }
}

enum TimeFrameType {
  daily,
  weekly,
  monthly,
}