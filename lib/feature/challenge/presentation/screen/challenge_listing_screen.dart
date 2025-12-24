// lib/feature/challenges/presentation/screens/challenges_list_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/navigation/app_router.gr.dart';
import 'package:routiner/feature/challenge/domain/entity/challenge_entity.dart';
import 'package:routiner/feature/challenge/presentation/bloc/challenge_list_bloc/challenge_list_bloc.dart';
import 'package:routiner/feature/challenge/presentation/widgets/challenge_card.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';

@RoutePage()
class ChallengesListScreen extends StatelessWidget {
  const ChallengesListScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ChallengesListBloc>(
      create: (_) =>
          AppInjector.getIt<ChallengesListBloc>()
            ..add(const LoadAllChallenges()),
      child: const _ChallengesScaffold(),
    );
  }
}

class _ChallengesScaffold extends StatelessWidget {
  const _ChallengesScaffold();

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.locale.challenges),
      backgroundColor: context.appColors.cF6F9FF,
      floatingActionButton: const _CreateChallengeFab(),
      body: const _ChallengesBody(),
    );
  }
}

class _ChallengesBody extends StatelessWidget {
  const _ChallengesBody();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ChallengesListBloc, ChallengesListState>(
      builder: (final BuildContext context, final ChallengesListState state) {
        if (state is ChallengesListLoading) {
          return const _LoadingView();
        }

        if (state is ChallengesListError) {
          return _ErrorView(message: state.message);
        }

        if (state is ChallengesListLoaded) {
          if (state.challenges.isEmpty) {
            return const _EmptyChallengesView();
          }

          return _ChallengesList(challenges: state.challenges);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
class _ChallengesList extends StatelessWidget {
  const _ChallengesList({required this.challenges});

  final List<ChallengeEntity> challenges;

  @override
  Widget build(final BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ChallengesListBloc>().add(const RefreshChallenges());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (final BuildContext context, final int index) {
          return ChallengeCard(
            challenge: challenges[index],
            onRefresh: () {
              context.read<ChallengesListBloc>().add(const RefreshChallenges());
            },
          );
        },
      ),
    );
  }
}
class _EmptyChallengesView extends StatelessWidget {
  const _EmptyChallengesView();

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: context.appColors.slate,
          ),
          const SizedBox(height: 16),
          Text(context.locale.noChallengesYet),
          const SizedBox(height: 8),
          Text(context.locale.createFirstChallenge),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.error_outline, size: 64, color: context.appColors.red),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ChallengesListBloc>().add(const LoadAllChallenges());
            },
            child: Text(context.locale.retry),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(final BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
class _CreateChallengeFab extends StatelessWidget {
  const _CreateChallengeFab();

  @override
  Widget build(final BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: context.appColors.c3843FF,
      icon: Icon(Icons.add, color: context.appColors.white),
      label: Text(
        context.locale.createChallenge,
        style: AppTextStyles.airbnbCerealW500S18Lh24.copyWith(
          color: context.appColors.white,
        ),
      ),
      onPressed: () async {
        final Object? result = await context.router.push(
          const CreateChallengeRoute(),
        );
        if (!context.mounted) {
          return;
        }
        if (result == true) {
          context.read<ChallengesListBloc>().add(
            const RefreshChallenges(forceRemote: true),
          );
        }
      },
    );
  }
}