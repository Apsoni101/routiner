import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/add_habit/presentation/bloc%20/mood_bloc.dart';
import 'package:routiner/feature/add_habit/presentation/widgets/habit_bottom_sheet.dart';
import 'package:routiner/feature/add_habit/presentation/widgets/mood_selector.dart';
import 'package:routiner/feature/add_habit/presentation/widgets/overlay_button.dart';

class AddHabitOverlay {
  /// Controller lives as long as overlay lives
  static OverlayEntry create(
    final BuildContext context, {
    required final VoidCallback onDismiss,
  }) {
    return OverlayEntry(
      builder: (_) => BlocProvider<MoodBloc>(
        create: (_) => AppInjector.getIt<MoodBloc>(),
        child: Stack(
          children: <Widget>[
            /// 🌫️ BLUR BACKGROUND
            Positioned.fill(
              child: GestureDetector(
                onTap: onDismiss,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: ColoredBox(color: Colors.black.withValues(alpha: 0.4)),
                ),
              ),
            ),

            /// 🪟 CONTENT
            Positioned(
              left: 12,
              right: 12,
              bottom: 32,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  /// TOP BUTTONS
                  Row(
                    spacing: 8,
                    children: <Widget>[
                      Expanded(
                        child: OverlayButton(
                          title: context.locale.quitBadHabit,
                          subtitle: context.locale.neverTooLate,
                          icon: AppAssets.badHabitIc,
                          onPressed: () {
                            onDismiss();
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => HabitBottomSheet(
                                title: context.locale.quitBadHabit,
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: OverlayButton(
                          title: context.locale.newGoodHabit,
                          subtitle: context.locale.forABetterLife,
                          icon: AppAssets.goodHabitIc,
                          onPressed: () {
                            onDismiss();
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => HabitBottomSheet(
                                title: context.locale.newGoodHabit,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  /// MOOD CARD
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.appColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                context.locale.addMood,
                                style: AppTextStyles.airbnbCerealW500S14Lh20
                                    .copyWith(color: context.appColors.black),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                context.locale.howAreYouFeeling,
                                style: AppTextStyles.airbnbCerealW400S12Lh16
                                    .copyWith(color: context.appColors.slate),
                              ),
                            ],
                          ),
                        ),

                        /// MOOD SELECTOR
                        const MoodSelector(),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: onDismiss,
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    icon: SvgPicture.asset(
                      AppAssets.crossIc,
                      width: 64,
                      height: 64,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
