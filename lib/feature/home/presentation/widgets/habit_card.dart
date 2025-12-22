// lib/feature/habit_display/presentation/widgets/habit_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';

import 'package:routiner/core/enums/log_status.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_log_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_with_log.dart';
import 'package:routiner/feature/home/presentation/widgets/friends_avatar_stack.dart';
import 'package:routiner/feature/home/presentation/widgets/update_value_dialog.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    required this.habitWithLog,
    required this.onStatusChange,
    required this.onValueUpdated,
    this.friendsCount = 0,
    super.key,
  });

  final HabitWithLog habitWithLog;
  final VoidCallback onValueUpdated;
  final void Function(LogStatus status, int? completedValue) onStatusChange;
  final int friendsCount;


  @override
  Widget build(final BuildContext context) {
    return Slidable(
      key: ValueKey(habitWithLog.habit.id),

      startActionPane: ActionPane(
        extentRatio: 0.38,
        motion: const DrawerMotion(),
        children: <Widget>[
          Flexible(
            child: _ActionContainer(
              children: <Widget>[
                _ActionItem(
                  path: AppAssets.eyeIc,
                  label: context.locale.view,
                  onTap: () {
                    // Example: open details screen
                  },
                ),
                const SizedBox(width: 12),
                VerticalDivider(
                  thickness: 1,
                  indent: 18,
                  endIndent: 18,
                  color: context.appColors.cEAECF0,
                ),

                const SizedBox(width: 12),

                _ActionItem(
                  path: AppAssets.rightIc,
                  label: context.locale.done,
                  onTap: () {
                    // Pass the goal value as completed value when marking as done
                    final int? completedValue = habitWithLog.habit.goalValue;
                    onStatusChange(LogStatus.completed, completedValue);
                    Slidable.of(context)?.close();
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      endActionPane: ActionPane(
        extentRatio: 0.38,
        motion: const DrawerMotion(),
        children: <Widget>[
          Flexible(
            child: _ActionContainer(
              children: <Widget>[
                _ActionItem(
                  path: AppAssets.closeIc,
                  label: context.locale.fail,
                  onTap: () {
                    onStatusChange(LogStatus.failed, null);
                    Slidable.of(context)?.close();
                  },
                ),
                const SizedBox(width: 12),
                VerticalDivider(
                  thickness: 1,
                  indent: 18,
                  endIndent: 18,
                  color: context.appColors.cEAECF0,
                ),
                const SizedBox(width: 12),
                _ActionItem(
                  path: AppAssets.rightArrowIc,
                  label: context.locale.skip,
                  onTap: () {
                    onStatusChange(LogStatus.skipped, null);
                    Slidable.of(context)?.close();
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      child: _HabitCardContent(
        habitWithLog: habitWithLog,
        onValueUpdated: onValueUpdated,
        friendsCount: friendsCount,

      ),
    );
  }
}

class _ActionContainer extends StatelessWidget {
  const _ActionContainer({required this.children});

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.cEAECF0, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

/// 🧠 One action inside the box
class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.path,
    required this.label,
    required this.onTap,
  });

  final String path;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(path, width: 20, height: 20),
          Text(
            label,
            style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
              color: context.appColors.c9B9BA1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitCardContent extends StatelessWidget {
  const _HabitCardContent({
    required this.habitWithLog,
    required this.onValueUpdated,
    required this.friendsCount,

  });

  final HabitWithLog habitWithLog;
  final VoidCallback onValueUpdated;
  final int friendsCount;


  Color _getStatusColor(
    final LogStatus? status,
    final double progress,
    final BuildContext context,
  ) {
    if (status == null && progress > 0 && progress < 1) {
      return context.appColors.c3843FF;
    }

    switch (status) {
      case LogStatus.completed:
        return Colors.green;
      case LogStatus.failed:
        return Colors.red;
      case LogStatus.skipped:
        return Colors.orange;
      default:
        return context.appColors.c3843FF;
    }
  }

  Future<void> _showUpdateValueDialog(final BuildContext context) async {
    final CustomHabitEntity habit = habitWithLog.habit;
    final HabitLogEntity log = habitWithLog.log;

    if (habit.goalValue == null || habit.goalUnit == null) {
      // If no goal value or unit, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This habit has no measurable goal'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final bool? success = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (final BuildContext dialogContext) => UpdateValueDialog(
        log: log,
        maxValue: habit.goalValue!,
        currentValue: log.completedValue ?? 0,
        unit: habit.goalUnit!.name,
        habitName: habit.name ?? 'Unnamed Habit',
      ),
    );

    // If update was successful, call the callback to refresh
    if (success ?? false) {
      onValueUpdated();
    }
  }

  @override
  Widget build(final BuildContext context) {
    final CustomHabitEntity habit = habitWithLog.habit;
    final HabitLogEntity log = habitWithLog.log;
    final double progress = _getProgress(habit, log);

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.cCDCDD0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 2,
                backgroundColor: context.appColors.cEAECF0,
                valueColor: AlwaysStoppedAnimation(
                  _getStatusColor(log.status, progress, context),
                ),
              ),

              _buildHabitIcon(context, habit.icon, habit.habitIconPath),
            ],
          ),
        ),
        title: Text(
          habit.name ?? 'Unnamed Habit',
          style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
            color: context.appColors.c040415,
          ),
        ),

        ///put in this goal values like 10/1000 ml
        subtitle: Text(
          _buildGoalText(habit, log),
          style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
            color: context.appColors.c9B9BA1,
          ),
        ),
        trailing: Row(
          spacing: 2,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             FriendsAvatarStack(
              friendsCount: friendsCount,
              avatarImages: const <ImageProvider<Object>>[
                AssetImage(AppAssets.avatar1Png),
                AssetImage(AppAssets.avatar2Png),
              ],
            ),
            SvgIconButton(
              svgPath: AppAssets.addButtonIc,
              onPressed: () => _showUpdateValueDialog(context),
              iconSize: 36,
            ),
          ],
        ),
      ),
    );
  }
}

String _buildGoalText(final CustomHabitEntity habit, final HabitLogEntity log) {
  if (habit.goalValue == null || habit.goalUnit == null) {
    return habit.goal ?? '';
  }

  final int completed = log.completedValue ?? 0;
  final int total = habit.goalValue!;
  final String unit = habit.goalUnit!.name;

  return '$completed / $total ${unit.toUpperCase()}';
}

double _getProgress(final CustomHabitEntity habit, final HabitLogEntity log) {
  if (habit.goalValue == null || habit.goalValue == 0) {
    return 0;
  }
  final int completed = log.completedValue ?? 0;
  return (completed / habit.goalValue!).clamp(0.0, 1.0);
}

Widget _buildHabitIcon(
  final BuildContext context,
  final dynamic icon,
  final String? habitIconPath,
) {
  if (habitIconPath != null && habitIconPath.isNotEmpty) {
    if (habitIconPath.endsWith('.svg')) {
      return SvgPicture.asset(habitIconPath, width: 20, height: 20);
    }
    return Image.asset(
      habitIconPath,
      width: 20,
      height: 20,
      fit: BoxFit.contain,
    );
  }
  if (icon is IconData) {
    return Icon(icon, size: 20);
  }

  return const Icon(Icons.task_alt, size: 20);
}
