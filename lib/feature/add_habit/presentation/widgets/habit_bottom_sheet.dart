import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/add_habit/presentation/widgets/create_habit_button.dart';

class HabitBottomSheet extends StatelessWidget {
  const HabitBottomSheet({required this.title, super.key, this.padding});

  final String title;
  final EdgeInsets? padding;

  @override
  Widget build(final BuildContext context) {
    return ClipPath(
      clipper: _TopWaveClipper(),
      child: ColoredBox(
        color: context.appColors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
          shrinkWrap: true,
          children: <Widget>[
            CircleAvatar(radius: 8, backgroundColor: context.appColors.cEAECF0),

            const SizedBox(height: 26),

            /// Title
            Text(
              title.toUpperCase(),
              style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
                color: context.appColors.c9B9BA1,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 8),

            /// Create button
            CreateHabitButton(onPressed: () {
              context.router.push(const CreateCustomHabitRoute());
            }),

            const SizedBox(height: 12),

            /// Popular habits title
            Text(
              context.locale.popularHabits.toUpperCase(),
              style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
                color: context.appColors.c9B9BA1,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 12),

            /// Horizontal habit cards
            SizedBox(
              height: MediaQuery.heightOf(context) * 0.14,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: Habit.values.length,
                itemBuilder: (context, index) {
                  final habit = Habit.values[index];
                  return _HabitCard(habit: habit);
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Habit Card
/// ---------------------------------------------------------------------------
class _HabitCard extends StatelessWidget {
  const _HabitCard({required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.25,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: habit.color(context.appColors).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Habit name
            Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: context.appColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: AlignmentDirectional.topStart,
              child: Image.asset(habit.path),
            ),
            const SizedBox(height: 8),
            Text(
              habit.label,
              textAlign: TextAlign.start,
              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                color: context.appColors.c040415,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '${habit.defaultValue} ${habit.unit}',
              textAlign: TextAlign.start,
              style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                color: context.appColors.c686873,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Top wave clipper
/// ---------------------------------------------------------------------------
class _TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(final Size size) {
    const double cornerRadius = 52;
    const double notchDepth = 20;
    const double notchWidth = 140;
    const double topPadding = 30;
    const double smoothness = 0.6;

    final double centerX = size.width / 2;

    final Path path = Path()
      ..moveTo(0, topPadding + cornerRadius)
      ..quadraticBezierTo(0, topPadding, cornerRadius, topPadding)
      ..lineTo(centerX - notchWidth / 2, topPadding)
      ..cubicTo(
        centerX - notchWidth / 2 * smoothness,
        topPadding,
        centerX - notchWidth / 4,
        topPadding - notchDepth,
        centerX,
        topPadding - notchDepth,
      )
      ..cubicTo(
        centerX + notchWidth / 4,
        topPadding - notchDepth,
        centerX + notchWidth / 2 * smoothness,
        topPadding,
        centerX + notchWidth / 2,
        topPadding,
      )
      ..lineTo(size.width - cornerRadius, topPadding)
      ..quadraticBezierTo(
        size.width,
        topPadding,
        size.width,
        topPadding + cornerRadius,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
