import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/feature/activity/domain/entity/mood_chart_data_point.dart';
import 'package:routiner/feature/activity/presentation/widgets/mood_chart_widget.dart';


class MoodChartContainer extends StatelessWidget {
  const MoodChartContainer({
    required this.title,
    required this.subtitle,
    required this.isLoading,
    required this.moodChartData,
    required this.timeFrameType,
    required this.emptyMessage,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool isLoading;
  final List<MoodChartDataPoint> moodChartData;
  final TimeFrameType timeFrameType;
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
            leading: Image.asset(AppAssets.smileIc, width: 36, height: 36),
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
          else if (moodChartData.isEmpty)
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
            MoodChart(
              chartData: moodChartData,
              timeFrameType: timeFrameType,
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}