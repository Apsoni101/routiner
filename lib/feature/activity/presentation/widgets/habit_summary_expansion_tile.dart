import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/activity/domain/entity/activity_summary_entity.dart';
import 'package:routiner/feature/common/presentation/widgets/profile_points_badge.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';

class HabitSummaryExpansionTile extends StatefulWidget {
  const HabitSummaryExpansionTile({
    super.key,
    this.summary,
    this.isLoading = false,
  });

  final ActivitySummaryEntity? summary;
  final bool isLoading;

  @override
  State<HabitSummaryExpansionTile> createState() =>
      _HabitSummaryExpansionTileState();
}

class _HabitSummaryExpansionTileState extends State<HabitSummaryExpansionTile>
    with SingleTickerProviderStateMixin {
  late final ExpansibleController _controller;
  late final AnimationController _rotationController;
  late final ValueNotifier<bool> _isExpandedNotifier;

  @override
  void initState() {
    super.initState();
    _controller = ExpansibleController();
    _isExpandedNotifier = ValueNotifier<bool>(false);
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _isExpandedNotifier.addListener(() {
      if (_isExpandedNotifier.value) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _isExpandedNotifier.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (_isExpandedNotifier.value) {
      _controller.collapse();
    } else {
      _controller.expand();
    }
  }

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.appColors.black.withValues(alpha: 0.2),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: _controller,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          onExpansionChanged: (final bool expanded) {
            _isExpandedNotifier.value = expanded;
          },
          leading: Image.asset(AppAssets.lookingEyeIc, width: 36, height: 36),
          title: Text(
            context.locale.allHabits,
            style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
              color: context.appColors.c040415,
            ),
          ),
          subtitle: Text(
            context.locale.summary,
            style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
              color: context.appColors.c9B9BA1,
            ),
          ),
          trailing: RotationTransition(
            turns: Tween<double>(
              begin: 0,
              end: 0.5,
            ).animate(_rotationController),
            child: SvgIconButton(
              svgPath: AppAssets.bottomArrowIc,
              onPressed: _toggleExpansion,
              padding: EdgeInsets.zero,
              iconSize: 36,
            ),
          ),
          children: <Widget>[
            if (widget.isLoading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (widget.summary != null)
              _buildSummaryContent(context, widget.summary!)
            else
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No data available',
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: context.appColors.c686873,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContent(
    final BuildContext context,
    final ActivitySummaryEntity summary,
  ) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.locale.successRate.toUpperCase(),
                style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase
                    .copyWith(color: context.appColors.c9B9BA1),
              ),
              Text(
                '${summary.successRate.toStringAsFixed(0)}%',
                style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
                  color: context.appColors.c3BA935,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.locale.pointsEarned.toUpperCase(),
                style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase
                    .copyWith(color: context.appColors.c9B9BA1),
              ),
              ProfilePointsBadge(points: '${summary.pointsEarned}'),
              const SizedBox(height: 4),
              Text(
                context.locale.skipped.toUpperCase(),
                style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase
                    .copyWith(color: context.appColors.c9B9BA1),
              ),
              Text(
                '${summary.skipped}',
                style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
                  color: context.appColors.c040415,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.locale.completed.toUpperCase(),
                style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase
                    .copyWith(color: context.appColors.c9B9BA1),
              ),
              Text(
                '${summary.completed}',
                style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
                  color: context.appColors.c040415,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.locale.bestStreakDay.toUpperCase(),
                style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase
                    .copyWith(color: context.appColors.c9B9BA1),
              ),
              Text(
                '${summary.bestStreakDay}',
                style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
                  color: context.appColors.c040415,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.locale.failed.toUpperCase(),
                style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase
                    .copyWith(color: context.appColors.c9B9BA1),
              ),
              Text(
                '${summary.failed}',
                style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
                  color: context.appColors.red,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }
}
