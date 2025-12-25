import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/extensions/time_of_day_extension.dart';
import 'package:routiner/core/localisation/app_localizations.dart';
import 'package:routiner/feature/profile/domain/entity/achievement_entity.dart';
import 'package:routiner/feature/profile/presentation/bloc/achievements_bloc/achievement_bloc.dart';

class AchievementsTabView extends StatelessWidget {
  const AchievementsTabView({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<AchievementsBloc>(
      create: (final BuildContext context) =>
          AppInjector.getIt<AchievementsBloc>()..add(const LoadAchievements()),
      child: const _AchievementsContent(),
    );
  }
}

class _AchievementsContent extends StatelessWidget {
  const _AchievementsContent();

  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<AchievementsBloc, AchievementsState>(
      listener: (final BuildContext context, final AchievementsState state) {
        if (state is AchievementsLoaded && state.newlyUnlocked.isNotEmpty) {
          _showUnlockDialog(context, state.newlyUnlocked);
          if (context.mounted) {
            context.read<AchievementsBloc>().add(
              const ClearAchievementNotifications(),
            );
          }
        }
      },
      builder: (final BuildContext context, final AchievementsState state) {
        final AppLocalizations loc = context.locale;

        if (state is AchievementsLoading) {
          return const _LoadingState();
        }

        if (state is AchievementsError) {
          return _ErrorState(
            message: state.message,
            onRetry: () =>
                context.read<AchievementsBloc>().add(const LoadAchievements()),
          );
        }

        if (state is AchievementsLoaded) {
          final List<AchievementEntity> unlocked = context
              .read<AchievementsBloc>()
              .getSortedUnlockedAchievements(state.achievements);

          if (unlocked.isEmpty) {
            return _EmptyState(
              onRefresh: () => context.read<AchievementsBloc>().add(
                const RefreshAchievements(),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${unlocked.length} ${context.locale.achievements}',
                  style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                    color: context.appColors.c040415,
                  ),
                ),
                const SizedBox(height: 8),
                _AchievementsListView(
                  achievements: unlocked,
                  onRefresh: () => context.read<AchievementsBloc>().add(
                    const RefreshAchievements(),
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
          child: Text(
            loc.noAchievements,
            style: AppTextStyles.airbnbCerealW500S14,
          ),
        );
      },
    );
  }

  void _showUnlockDialog(
    final BuildContext context,
    final List<AchievementEntity> unlocked,
  ) {
    final AppLocalizations loc = context.locale;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (final BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: context.appColors.c040415,
        title: Row(
          children: <Widget>[
            const Text('🎉'),
            const SizedBox(width: 8),
            Text(
              loc.achievementUnlocked,
              style: AppTextStyles.airbnbCerealW700S24Lh32LsMinus1.copyWith(
                color: context.appColors.white,
              ),
            ),
          ],
        ),
        content: ListView(
          shrinkWrap: true,
          children: unlocked
              .map(
                (final AchievementEntity a) =>
                    _UnlockDialogItem(achievement: a),
              )
              .toList(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              loc.awesome,
              style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
                color: context.appColors.cFEA800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations loc = context.locale;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          loc.loadingAchievements,
          style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
            color: context.appColors.slate,
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations loc = context.locale;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error_outline, size: 64, color: context.appColors.red),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
            color: context.appColors.white,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.appColors.primaryBlue,
            foregroundColor: context.appColors.white,
          ),
          icon: const Icon(Icons.refresh),
          label: Text(
            loc.retry,
            style: AppTextStyles.airbnbCerealW500S14Lh20Ls0,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations loc = context.locale;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.emoji_events_outlined,
          size: 64,
          color: context.appColors.slate,
        ),
        const SizedBox(height: 16),
        Text(
          loc.noAchievementsYet,
          style: AppTextStyles.airbnbCerealW700S24Lh32LsMinus1.copyWith(
            color: context.appColors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          loc.startCompletingHabits,
          textAlign: TextAlign.center,
          style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
            color: context.appColors.slate,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: onRefresh,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.appColors.primaryBlue,
            foregroundColor: context.appColors.white,
          ),
          icon: const Icon(Icons.refresh),
          label: Text(
            loc.refresh,
            style: AppTextStyles.airbnbCerealW500S14Lh20Ls0,
          ),
        ),
      ],
    );
  }
}

class _AchievementsListView extends StatelessWidget {
  const _AchievementsListView({
    required this.achievements,
    required this.onRefresh,
  });

  final List<AchievementEntity> achievements;
  final VoidCallback onRefresh;

  @override
  Widget build(final BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: achievements.length + 1,
          itemBuilder: (final BuildContext context, final int index) {
            if (index == achievements.length) {
              return const SizedBox(height: 16);
            }
            return _AchievementCard(achievement: achievements[index]);
          },
        ),
      ),
    );
  }
}

class _UnlockDialogItem extends StatelessWidget {
  const _UnlockDialogItem({required this.achievement});

  final AchievementEntity achievement;

  @override
  Widget build(final BuildContext context) {
    final AppLocalizations loc = context.locale;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: achievement.tier.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: achievement.tier.color, width: 2),
      ),
      child: Column(
        children: <Widget>[
          Text(achievement.iconPath, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.airbnbCerealW700S24Lh32LsMinus1.copyWith(
              color: context.appColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            achievement.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
              color: context.appColors.slate,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.appColors.cFEA800,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              loc.pointsReward(achievement.pointsReward),
              style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
                color: context.appColors.c040415,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final AchievementEntity achievement;

  @override
  Widget build(final BuildContext context) {
    final String unlockedDate = achievement.unlockedAt.formatUnlockDate();

    return Container(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.appColors.white,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          achievement.title,
          style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
            color: context.appColors.c040415,
          ),
        ),
        subtitle: Text(
          unlockedDate,
          style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
            color: context.appColors.c9B9BA1,
          ),
        ),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: achievement.tier.color.withValues(alpha: 0.2),
          child: Center(
            child: Text(
              achievement.iconPath,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
