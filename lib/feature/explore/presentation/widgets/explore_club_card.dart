import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/club_image_extension.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/explore/presentation/bloc/explore_bloc/explore_bloc.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';

/// Individual club card for explore
class ExploreClubCard extends StatelessWidget {
  const ExploreClubCard({
    required this.club,
    required this.currentUserId,
    required this.isMember,
    required this.isPending,
    required this.isLoading,
    super.key,
  });

  final ClubEntity club;
  final String currentUserId;
  final bool isMember;
  final bool isPending;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: isMember ? () => _openChat(context) : null,
      child: AspectRatio(
        aspectRatio: 1.25,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: context.appColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.appColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: context.appColors.cEAECF0),
                    ),
                    child: _buildClubImage(),
                  ),
                  const Spacer(),
                  if (!isMember)
                    GestureDetector(
                      onTap: (isPending || isLoading)
                          ? null
                          : () {
                              context.read<ExploreBloc>().add(
                                RequestToJoinClubFromExploreEvent(club.id),
                              );
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              isPending
                                  ? Icons.hourglass_top
                                  : Icons.add_circle_outline,
                              size: 20,
                              color: context.appColors.c000DFF,
                            ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                club.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                  color: context.appColors.c040415,
                ),
              ),
              Text(
                '${club.memberIds.length} ${club.memberIds.length == 1 ? context.locale.member : context.locale.members}',
                style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                  color: context.appColors.c686873,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClubImage() {
    final String? image = club.imageUrl;

    if (image.isIcon) {
      return Icon(image.toIconData, size: 24);
    }

    if (image.isNetwork) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          image!,
          fit: BoxFit.cover,
          errorBuilder: (_, final __, final ___) =>
              Image.asset(AppAssets.appLogoIc),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        image.safeImage,
        fit: BoxFit.cover,
        errorBuilder: (_, final __, final ___) =>
            Image.asset(AppAssets.appLogoIc),
      ),
    );
  }

  void _openChat(final BuildContext context) {
    context.router.push(
      ClubChatRoute(
        club: club,
        currentUserId: currentUserId,
        onMemberRemoved: (final String userId) {
          context.read<ExploreBloc>().add(
            RemoveMemberFromExploreEvent(clubId: club.id, userId: userId),
          );
        },
        onLeaveClub: () {
          context.read<ExploreBloc>().add(LeaveClubFromExploreEvent(club.id));
          context.router.pop();
        },
      ),
    );
  }
}
