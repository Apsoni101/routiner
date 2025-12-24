import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/activity/domain/entity/chart_data_point_entity.dart';

class ActivityChart extends StatelessWidget {
  const ActivityChart({required this.chartData, super.key});

  final List<ChartDataPoint> chartData;

  @override
  Widget build(final BuildContext context) {
    final Size mediaSize = MediaQuery.sizeOf(context);

    if (chartData.isEmpty) {
      return SizedBox(
        height: mediaSize.height * 0.16,
        child: const Center(child: Text('No data available')),
      );
    }

    final double maxY = chartData
        .map((final ChartDataPoint e) => e.totalTasks.toDouble())
        .reduce((final double a, final double b) => a > b ? a : b);
    final double yInterval = maxY > 0 ? (maxY / 4).ceilToDouble() : 10;

    return SizedBox(
      height: mediaSize.height * 0.16,
      width: mediaSize.width,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (chartData.length - 1).toDouble(),
          minY: 0,
          maxY: maxY + yInterval,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: yInterval,
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
            leftTitles: const AxisTitles(),
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
                        chartData[index].label,
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
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              isCurved: true,
              color: context.appColors.c3843FF,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    context.appColors.c3843FF.withValues(alpha: 0.3),
                    context.appColors.c3843FF.withValues(alpha: 0.05),
                  ],
                ),
              ),
              dotData: const FlDotData(show: false),
              spots: List<FlSpot>.generate(
                chartData.length,
                (final int index) => FlSpot(
                  index.toDouble(),
                  chartData[index].completedTasks.toDouble(),
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(10),
              tooltipMargin: 8,
              getTooltipColor: (final LineBarSpot touchedSpot) {
                return context.appColors.white;
              },

              getTooltipItems: (final List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((final LineBarSpot spot) {
                  final int index = spot.x.toInt();
                  final ChartDataPoint data = chartData[index];

                  return LineTooltipItem(
                    '',
                    const TextStyle(),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${context.locale.burn}\n',
                        style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                          color: context.appColors.c040415,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' ${data.completedTasks}  ${context.locale.habits}',
                        style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                          color: context.appColors.c9B9BA1,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),

          extraLinesData: ExtraLinesData(
            verticalLines: <VerticalLine>[
              for (int i = 0; i < chartData.length; i++)
                if (chartData[i].isToday)
                  VerticalLine(
                    x: i.toDouble(),
                    color: context.appColors.c3843FF.withValues(alpha: 0.2),
                    strokeWidth: 4,
                  ),
            ],
            horizontalLines: <HorizontalLine>[
              HorizontalLine(
                y: yInterval * 4,
                color: context.appColors.cEAECF0,
                strokeWidth: 1,
                dashArray: <int>[6, 6],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
