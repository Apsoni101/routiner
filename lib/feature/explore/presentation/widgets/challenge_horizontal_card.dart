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

class ChallengeHorizontalCard extends StatelessWidget {
  const ChallengeHorizontalCard({
    required this.challenge,
    required this.cardWidth,
    required this.sectionHeight,
    this.onRefresh,
    super.key,
  });

  final ChallengeEntity challenge;
  final double cardWidth;
  final double sectionHeight;
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
        if (challenge.id == null || challenge.id!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid challenge - missing ID'),
              backgroundColor: Colors.red,
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
        width: cardWidth,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.appColors.c000DFF.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(AppAssets.timeWhiteIc, height: 24, width: 24),
            const SizedBox(height: 8),
            Text(
              '${challenge.title} ${challenge.emoji?.symbol ?? ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                color: context.appColors.white,
              ),
            ),
            Text(
              '${challenge.duration} ${challenge.durationType?.name ?? ''} ${context.locale.left}',
              maxLines: 1,
              style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                color: context.appColors.white,
                fontSize: 10,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                color: context.appColors.white,
                backgroundColor: context.appColors.white.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                FriendsAvatarStack(
                  friendsCount: participantCount,
                  avatarImages: const <ImageProvider<Object>>[
                    AssetImage(AppAssets.avatar1Png),
                    AssetImage(AppAssets.avatar2Png),
                  ],
                ),
                Text(
                  '$participantCount ${context.locale.friendsJoined}',
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                      color: context.appColors.white,
                      fontSize: 10
                  ),
                  textAlign: TextAlign.start,
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}