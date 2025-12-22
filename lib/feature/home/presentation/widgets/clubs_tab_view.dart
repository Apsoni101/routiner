import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/club_image_extension.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';
import 'package:routiner/feature/home/presentation/bloc/club_bloc/club_list_bloc.dart';
import 'package:routiner/feature/home/presentation/widgets/create_club_bottomsheet.dart';

class ClubsTabView extends StatelessWidget {
  const ClubsTabView({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ClubListBloc>(
      create: (_) => AppInjector.getIt<ClubListBloc>()..add(LoadClubsEvent()),
      child: const _ClubsBody(),
    );
  }
}

/// =======================================================
/// BODY
/// =======================================================
class _ClubsBody extends StatelessWidget {
  const _ClubsBody();

  Future<void> _openCreateClub(final BuildContext context) async {
    final ClubEntity? createdClub = await showModalBottomSheet<ClubEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateClubBottomSheet(),
    );

    if (createdClub != null && context.mounted) {
      context.read<ClubListBloc>().add(LoadClubsEvent());
    }
  }

  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<ClubListBloc, ClubListState>(
      listener: (final BuildContext context, final ClubListState state) {
        if (state is ClubError || state is ClubActionSuccess) {
          final String message = state is ClubError
              ? state.message
              : (state as ClubActionSuccess).message;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (final BuildContext context, final ClubListState state) {
        if (state is ClubLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ClubsLoaded) {
          // Check if both lists are empty
          if (state.allClubs.isEmpty && state.userClubs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.groups_outlined,
                      size: 64,
                      color: context.appColors.c686873,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.locale.noClubsAvailable,
                      style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                        color: context.appColors.c040415,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.locale.createFirstClubMessage,
                      style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                        color: context.appColors.c686873,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _openCreateClub(context),
                      icon: const Icon(Icons.add),
                      label: Text(context.locale.createClub),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: <Widget>[
              _SectionTitle(title: context.locale.allClubs),
              const SizedBox(height: 12),
              if (state.allClubs.isEmpty)
                _EmptyStateMessage(
                  message: context.locale.noClubsAvailableYet,
                )
              else
                _ClubGrid(
                  clubs: state.allClubs,
                  currentUserId: state.currentUserId,
                ),
              const SizedBox(height: 24),
              _SectionHeader(
                title: context.locale.myClubs,
                onAddPressed: () => _openCreateClub(context),
              ),
              const SizedBox(height: 12),
              if (state.userClubs.isEmpty)
                _EmptyStateMessage(
                  message: context.locale.noMyClubsYet,
                )
              else
                _ClubGrid(
                  clubs: state.userClubs,
                  currentUserId: state.currentUserId,
                  isMyClubs: true,
                ),
              const SizedBox(height: 120),
            ],
          );
        }

        return Center(child: Text(context.locale.noClubsAvailable));
      },
    );
  }
}

/// =======================================================
/// EMPTY STATE MESSAGE
/// =======================================================
class _EmptyStateMessage extends StatelessWidget {
  const _EmptyStateMessage({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.appColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appColors.cEAECF0),
      ),
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
            color: context.appColors.c686873,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// =======================================================
/// REUSABLE SECTION TITLE
/// =======================================================
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(final BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
        color: context.appColors.c040415,
      ),
    );
  }
}

/// =======================================================
/// SECTION HEADER WITH ADD BUTTON
/// =======================================================
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onAddPressed});

  final String title;
  final VoidCallback onAddPressed;

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _SectionTitle(title: title),
        SvgIconButton(
          svgPath: AppAssets.addButtonIc,
          iconSize: 36,
          padding: EdgeInsets.zero,
          onPressed: onAddPressed,
        ),
      ],
    );
  }
}

/// =======================================================
/// REUSABLE CLUB GRID
/// =======================================================
class _ClubGrid extends StatelessWidget {
  const _ClubGrid({
    required this.clubs,
    required this.currentUserId,
    this.isMyClubs = false,
  });

  final List<ClubEntity> clubs;
  final String currentUserId;
  final bool isMyClubs;

  @override
  Widget build(final BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: clubs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, final int index) {
        final ClubEntity club = clubs[index];

        final bool isMember = club.isMember(currentUserId);
        final bool isPending = club.hasPendingRequest(currentUserId);

        return _ClubCard(
          club: club,
          currentUserId: currentUserId,
          isMember: isMember || isMyClubs,
          isPending: isPending,
          onCardTap: isMyClubs || isMember
              ? () => _openChat(context, club)
              : null,
          onJoinTap: (isMyClubs || isMember || isPending)
              ? null
              : () => context.read<ClubListBloc>().add(
            RequestToJoinClubEvent(club.id),
          ),
        );
      },
    );
  }

  void _openChat(final BuildContext context, final ClubEntity club) {
    context.router.push(
      ClubChatRoute(
        club: club,
        currentUserId: currentUserId,
        onMemberRemoved: (final String userId) {
          context.read<ClubListBloc>().add(
            RemoveMemberEvent(clubId: club.id, userId: userId),
          );
        },
        onLeaveClub: () {
          context.read<ClubListBloc>().add(LeaveClubEvent(club.id));
          context.router.pop();
        },
      ),
    );
  }
}

/// =======================================================
/// REUSABLE CLUB CARD
/// =======================================================
class _ClubCard extends StatelessWidget {
  const _ClubCard({
    required this.club,
    required this.currentUserId,
    required this.isMember,
    required this.isPending,
    this.onCardTap,
    this.onJoinTap,
  });

  final ClubEntity club;
  final String currentUserId;
  final bool isMember;
  final bool isPending;
  final VoidCallback? onCardTap;
  final VoidCallback? onJoinTap;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: AspectRatio(
        aspectRatio: 1.25,
        child: Container(
          padding: const EdgeInsets.all(16),
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
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: context.appColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.appColors.cEAECF0),
                    ),
                    child: _buildClubImage(),
                  ),
                  const Spacer(),
                  if (!isMember)
                    GestureDetector(
                      onTap: onJoinTap,
                      child: Icon(
                        isPending
                            ? Icons.hourglass_top
                            : Icons.add_circle_outline,
                        size: 24,
                        color: isPending
                            ? context.appColors.c686873
                            : context.appColors.c000DFF,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                club.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                  color: context.appColors.c040415,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                club.description,
                textAlign: TextAlign.start,
                style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                  color: context.appColors.c686873,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
      return Icon(image.toIconData, size: 28);
    }

    if (image.isNetwork) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          image!,
          fit: BoxFit.cover,
          errorBuilder: (_, final __, final ___) {
            return Image.asset(AppAssets.appLogoIc);
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        image.safeImage,
        fit: BoxFit.cover,
        errorBuilder: (_, final __, final ___) =>
            Image.asset(AppAssets.appLogoIc),
      ),
    );
  }
}