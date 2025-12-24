import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/home/presentation/widgets/friends_avatar_stack.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    required this.challenge,
    this.onRefresh,
    super.key,
  });

  final ChallengeEntity challenge;
  final VoidCallback? onRefresh;

  /// Like checking how much juice is left in a bottle 🧃
  double _calculateProgress() {
    if (challenge.totalGoalValue == null || challenge.totalGoalValue == 0) {
      return 0;
    }

    final double progress =
        (challenge.completedValue ?? 0) / challenge.totalGoalValue!;

    return progress.clamp(0.0, 1.0);
  }

  @override
  Widget build(final BuildContext context) {
    final int participantCount = challenge.participantIds?.length ?? 0;
    final double progress = _calculateProgress();

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        // Add validation before navigation
        if (challenge.id == null || challenge.id!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('Invalid challenge - missing ID'),
              backgroundColor: context.appColors.red,
            ),
          );
          return;
        }

        await context.router.push(
          ChallengeDetailRoute(challengeId: challenge.id!),
        );

        if (!context.mounted) {
          return;
        }

        // Call the refresh callback if provided
        onRefresh?.call();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.appColors.black.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Icon
                SvgPicture.asset(AppAssets.timeBlueIc, height: 28, width: 28),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${challenge.title} ${challenge.emoji?.symbol ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.airbnbCerealW500S14Lh20Ls0
                            .copyWith(color: context.appColors.c040415),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${challenge.duration} ${challenge.durationType?.name ?? ''} ${context.locale.left}',
                        style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                          color: context.appColors.c9B9BA1,
                        ),
                      ),
                    ],
                  ),
                ),

                // Participants
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FriendsAvatarStack(
                      friendsCount: participantCount,
                      avatarImages: const <ImageProvider<Object>>[
                        AssetImage(AppAssets.avatar1Png),
                        AssetImage(AppAssets.avatar2Png),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$participantCount ${context.locale.friendsJoined}',
                      style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                        color: context.appColors.c9B9BA1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                color: context.appColors.c3843FF,
                backgroundColor: context.appColors.cEAECF0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}