// lib/feature/challenges/presentation/screens/challenge_detail_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/utils/toast_utils.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/presentation/bloc/challenge_detail_bloc/challenge_detail_bloc.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_button.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';
import 'package:routiner/feature/create_custom_habit/domain/entity/custom_habit_entity.dart';
import 'package:routiner/feature/home/domain/entity/habit_with_log.dart';
import 'package:routiner/feature/home/presentation/widgets/friends_avatar_stack.dart';
import 'package:routiner/feature/home/presentation/widgets/habit_card.dart';

@RoutePage()
class ChallengeDetailScreen extends StatelessWidget {
  const ChallengeDetailScreen({required this.challengeId, super.key});

  final String challengeId;

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ChallengeDetailBloc>(
      create: (_) =>
          AppInjector.getIt<ChallengeDetailBloc>()
            ..add(LoadChallengeDetail(challengeId)),
      child: const _ChallengeDetailView(),
    );
  }
}

class _ChallengeDetailView extends StatelessWidget {
  const _ChallengeDetailView();

  @override
  Widget build(final BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.challengeDetailBg),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<ChallengeDetailBloc, ChallengeDetailState>(
          listener:
              (final BuildContext context, final ChallengeDetailState state) {
                if (state is ChallengeDetailLoaded &&
                    state.errorMessage != null) {
                  ToastUtils.showToast(
                    context,
                    state.errorMessage!,
                    success: false,
                  );
                }
              },
          builder:
              (final BuildContext context, final ChallengeDetailState state) {
                return switch (state) {
                  ChallengeDetailLoading() => const _LoadingView(),
                  ChallengeDetailError() => _ErrorView(message: state.message),
                  ChallengeDetailLoaded() => _ChallengeDetailContent(
                    challenge: state.challenge,
                    habits: state.habits,
                    friendsCount: state.friendsCount,
                    currentUserId: state.currentUserId,
                    habitsWithLogs: state.habitsWithLogs,
                    habitFriendsCountMap: state.habitFriendsCountMap,
                  ),
                  _ => const SizedBox.shrink(),
                };
              },
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.appColors.white),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error_outline, size: 64, color: context.appColors.red),
        const SizedBox(height: 16),
        Text(message),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => context.router.pop(),
          child: const Text('Go Back'),
        ),
      ],
    );
  }
}

class _ChallengeDetailContent extends StatelessWidget {
  const _ChallengeDetailContent({
    required this.challenge,
    required this.habits,
    required this.friendsCount,
    required this.habitsWithLogs,
    required this.habitFriendsCountMap,
    this.currentUserId,
  });

  final ChallengeEntity challenge;
  final List<CustomHabitEntity> habits;
  final int friendsCount;
  final String? currentUserId;
  final List<HabitWithLog> habitsWithLogs;
  final Map<String, int> habitFriendsCountMap;

  bool get _hasJoined =>
      currentUserId != null &&
      (challenge.participantIds ?? <String>[]).contains(currentUserId);

  void _handleJoinChallenge(final BuildContext context) {
    final String? challengeId = challenge.id;
    if (challengeId != null) {
      context.read<ChallengeDetailBloc>().add(
        JoinChallenge(challengeId: challengeId),
      );
    } else {
      ToastUtils.showToast(context, 'Invalid challenge ID', success: false);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SvgIconButton(
              svgPath: AppAssets.leftIc,
              onPressed: () => context.router.pop(),
              iconSize: 48,
            ),
            SvgIconButton(
              svgPath: AppAssets.addButtonIc,
              onPressed: () {},
              iconSize: 48,
            ),
          ],
        ),
        const SizedBox(height: 52),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              challenge.emoji?.symbol ?? '',
              style: const TextStyle(
                fontSize: 48,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              challenge.title ?? '',
              style: AppTextStyles.airbnbCerealW700S24Lh32LsMinus1.copyWith(
                color: context.appColors.cEBECFF,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              challenge.dateRangeText,
              style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
                color: context.appColors.cEBECFF,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 24),
            FriendsAvatarStack(
              friendsCount: friendsCount,
              avatarImages: const <ImageProvider<Object>>[
                AssetImage(AppAssets.avatar1Png),
                AssetImage(AppAssets.avatar2Png),
                AssetImage(AppAssets.avatar3Png),
                AssetImage(AppAssets.avatar4Png),
                AssetImage(AppAssets.avatar5Png),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              challenge.description ?? '',
              style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
                color: context.appColors.cEBECFF,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
        if (!_hasJoined)
          CustomButton(
            label: context.locale.joinChallenge,
            enabledTextColor: context.appColors.c040415,
            onPressed: () => _handleJoinChallenge(context),
            enabledColor: context.appColors.white,
          ),
        const SizedBox(height: 24),
        Text(
          context.locale.tasks,
          style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
            color: context.appColors.white,
            decoration: TextDecoration.none,
          ),
        ),
        if (habitsWithLogs.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                context.locale.noHabitsInChallenge,
                style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
                  color: context.appColors.cEBECFF,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: habitsWithLogs.length,
            itemBuilder: (context, index) {
              final habitWithLog = habitsWithLogs[index];
              final habitId = habitWithLog.habit.id ?? '';
              final friendsCount = habitFriendsCountMap[habitId] ?? 0;

              return HabitCard(
                habitWithLog: habitWithLog,
                friendsCount: friendsCount,
                onValueUpdated: () {
                  context.read<ChallengeDetailBloc>().add(
                    RefreshChallengeHabits(challenge.id!),
                  );
                },
                onStatusChange: (status, completedValue) {
                  context.read<ChallengeDetailBloc>().add(
                    UpdateChallengeHabitLog(
                      log: habitWithLog.log,
                      status: status,
                      completedValue: completedValue,
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
