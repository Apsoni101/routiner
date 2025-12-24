import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_constants.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/enums/habits.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/common/presentation/widgets/habit_horizontal_item_card.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';
import 'package:routiner/feature/explore/domain/entity/learning_entity.dart';
import 'package:routiner/feature/explore/presentation/bloc/explore_bloc/explore_bloc.dart';
import 'package:routiner/feature/explore/presentation/widgets/challenge_horizontal_card.dart';
import 'package:routiner/feature/explore/presentation/widgets/explore_club_card.dart';
import 'package:routiner/feature/explore/presentation/widgets/learning_card.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';
import 'package:routiner/feature/home/presentation/widgets/section_header.dart';

@RoutePage()
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ExploreBloc>(
      create: (_) =>
          AppInjector.getIt<ExploreBloc>()..add(LoadExploreDataEvent()),
      child: const _ExploreBody(),
    );
  }
}

class _ExploreBody extends StatelessWidget {
  const _ExploreBody();

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.cEAECF0,
      appBar: CustomAppBar(
        title: context.locale.explore,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SvgIconButton(
              padding: EdgeInsets.zero,
              svgPath: AppAssets.searchIc,
              onPressed: () {},
              iconSize: 48,
            ),
          ),
        ],
        showBackButton: false,
      ),
      body: BlocListener<ExploreBloc, ExploreState>(
        listenWhen: (final ExploreState previous, final ExploreState current) =>
            current is ExploreLoaded && current.successMessage != null,
        listener: (final BuildContext context, final ExploreState state) {
          if (state is ExploreLoaded && state.successMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
          }
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: <Widget>[
            SectionHeader(
              title: context.locale.suggestedForYou,
              actionText: context.locale.viewAll,
              onActionPressed: () {
                context.router.push(CreateCustomHabitRoute());
              },
            ),
            // Horizontal habit cards
            SizedBox(
              height: MediaQuery.heightOf(context) * 0.14,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: <Widget>[
                  const SizedBox(width: 24),
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: Habit.values.length,
                    itemBuilder: (final BuildContext context, final int index) {
                      final Habit habit = Habit.values[index];
                      return HabitHorizontalItemCard(
                        habit: habit,
                        onTap: () async {
                          final bool? result = await context.router.push(
                            CreateCustomHabitRoute(selectedHabit: habit),
                          );
                          if ((result ?? false) && context.mounted) {
                            context.router.pop(true);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            SectionHeader(
              title: context.locale.habitClubs,
              actionText: context.locale.viewAll,
              onActionPressed: () {
                context.router.navigate(HomeRoute(initialTab: 1));
              },
            ),
            // Clubs horizontal list
            const _ExploreClubsSection(),
            SectionHeader(
              title: context.locale.challenges,
              actionText: context.locale.viewAll,
              onActionPressed: () {
                context.router.push(const ChallengesListRoute());
              },
            ),
            // Challenges section
            const _ExploreChallengesSection(),
            SectionHeader(
              title: context.locale.learning,
              actionText: context.locale.viewAll,
              onActionPressed: () {},
            ),
            const _LearningSection(),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

class _LearningSection extends StatelessWidget {
  const _LearningSection();

  @override
  Widget build(final BuildContext context) {
    final double sectionHeight = MediaQuery.heightOf(context) * 0.18;
    final double cardWidth = MediaQuery.widthOf(context) * 0.5;

    return SizedBox(
      height: sectionHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: AppConstants.learnings.length,
        itemBuilder: (final BuildContext context, final int index) {
          final LearningItemEntity item = AppConstants.learnings[index];
          return LearningCard(
            imagePath: item.assetImage,
            iconPath: AppAssets.folderIc,
            title: item.title,
            sectionHeight: sectionHeight,
            cardWidth: cardWidth,
          );
        },
        separatorBuilder: (final BuildContext context, final int index) {
          return const SizedBox(width: 12);
        },
      ),
    );
  }
}

/// Clubs section widget
class _ExploreClubsSection extends StatelessWidget {
  const _ExploreClubsSection();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (final BuildContext context, final ExploreState state) {
        if (state is ExploreLoading) {
          return SizedBox(
            height: MediaQuery.heightOf(context) * 0.14,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ExploreLoaded) {
          // Show error if clubs failed to load
          if (state.clubsError != null) {
            return SizedBox(
              height: MediaQuery.heightOf(context) * 0.14,
              child: Center(
                child: Text(
                  state.clubsError!,
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: context.appColors.red,
                  ),
                ),
              ),
            );
          }

          // Show empty state if no clubs
          if (state.clubs == null || state.clubs!.isEmpty) {
            return SizedBox(
              height: MediaQuery.heightOf(context) * 0.14,
              child: Center(
                child: Text(
                  context.locale.noClubsAvailableYet,
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: context.appColors.c686873,
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            height: MediaQuery.heightOf(context) * 0.14,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: state.clubs!.length,
              itemBuilder: (final BuildContext context, final int index) {
                final ClubEntity club = state.clubs![index];
                final bool isMember = club.isMember(state.currentUserId ?? '');
                final bool isPending = club.hasPendingRequest(
                  state.currentUserId ?? '',
                );

                final bool isLoading = state.actionLoadingClubId == club.id;

                return ExploreClubCard(
                  club: club,
                  currentUserId: state.currentUserId ?? '',
                  isMember: isMember,
                  isPending: isPending,
                  isLoading: isLoading,
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// Challenges section widget
/// Challenges section widget
class _ExploreChallengesSection extends StatelessWidget {
  const _ExploreChallengesSection();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (final BuildContext context, final ExploreState state) {
        if (state is ExploreLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ExploreLoaded) {
          if (state.challengesError != null) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  state.challengesError!,
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: context.appColors.red,
                  ),
                ),
              ),
            );
          }

          if (state.challenges == null || state.challenges!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  context.locale.noChallengesYet,
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: context.appColors.c686873,
                  ),
                ),
              ),
            );
          }
          final double sectionHeight = MediaQuery.heightOf(context) * 0.18;
          final double cardWidth = MediaQuery.widthOf(context) * 0.5;

          return SizedBox(
            height: sectionHeight,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: state.challenges!.length,
              itemBuilder: (final BuildContext context, final int index) {
                return ChallengeHorizontalCard(
                  challenge: state.challenges![index],
                  cardWidth: cardWidth,
                  sectionHeight: sectionHeight,
                  onRefresh: () {
                    context.read<ExploreBloc>().add(LoadExploreDataEvent());
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
