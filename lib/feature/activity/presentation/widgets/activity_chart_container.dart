import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/feature/activity/domain/entity/chart_data_point_entity.dart';
import 'package:routiner/feature/activity/presentation/widgets/activity_chart.dart';

class ActivityChartContainer extends StatelessWidget {
  const ActivityChartContainer({
    required this.title,
    required this.subtitle,
    required this.isLoading,
    required this.chartData,
    required this.emptyMessage,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool isLoading;
  final List<ChartDataPoint> chartData;
  final String emptyMessage;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.appColors.black.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset(AppAssets.chartingIc, width: 36, height: 36),
            title: Text(
              title,
              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                color: context.appColors.c040415,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                color: context.appColors.c9B9BA1,
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (chartData.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  emptyMessage,
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: context.appColors.c9B9BA1,
                  ),
                ),
              ),
            )
          else
            ActivityChart(chartData: chartData),
          const  SizedBox(height: 32,)
        ],
      ),
    );
  }
}
