import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/core/utils/toast_utils.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/common/presentation/widgets/svg_button.dart';
import 'package:routiner/feature/profile/presentation/bloc/friend_remote_bloc/friend_remote_bloc.dart';
import 'package:routiner/feature/profile/presentation/widgets/add_friend_dialog.dart';
import 'package:routiner/feature/profile/presentation/widgets/friend_card.dart';

class FriendsTabView extends StatelessWidget {
  const FriendsTabView({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<FriendsRemoteBloc>(
      create: (final BuildContext context) =>
          AppInjector.getIt<FriendsRemoteBloc>()..add(LoadFriends()),
      child: Builder(
        builder: (final BuildContext context) {
          return BlocListener<FriendsRemoteBloc, FriendsRemoteState>(
            listener: (context, state) {
              if (state is FriendRemoved) {
                ToastUtils.showToast(
                  context,
                  context.locale.friendRemovedSuccess,
                  success: true,
                );
              }

              if (state is FriendsError) {
                ToastUtils.showToast(context, state.message, success: false);
              }
            },
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  title: BlocBuilder<FriendsRemoteBloc, FriendsRemoteState>(
                    builder:
                        (
                          final BuildContext context,
                          final FriendsRemoteState state,
                        ) {
                          final int count = state is FriendsLoaded
                              ? state.friends.length
                              : 0;

                          return Text(
                            '$count ${context.locale.friends}',
                            style: AppTextStyles.airbnbCerealW500S14Lh20Ls0
                                .copyWith(color: context.appColors.c040415),
                          );
                        },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SvgIconButton(
                        svgPath: AppAssets.addButtonIc,
                        iconSize: 36,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (_) =>
                                BlocProvider<FriendsRemoteBloc>.value(
                                  value: context.read<FriendsRemoteBloc>(),
                                  child: const AddFriendDialog(),
                                ),
                          );
                        },
                      ),
                      SvgIconButton(
                        svgPath: AppAssets.editIc,
                        padding: EdgeInsets.zero,
                        iconSize: 36,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const Expanded(child: _FriendsTabContent()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FriendsTabContent extends StatelessWidget {
  const _FriendsTabContent();

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<FriendsRemoteBloc, FriendsRemoteState>(
      builder: (final BuildContext context, final FriendsRemoteState state) {
        if (state is FriendsLoading || state is FriendActionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FriendsError) {
          return _FriendsErrorView(message: state.message);
        }

        if (state is FriendsLoaded) {
          if (state.friends.isEmpty) {
            return const _FriendsEmptyView();
          }

          return ListView.builder(
            padding:  const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.friends.length,
            itemBuilder: (final BuildContext context, final int index) {
              final UserEntity friend = state.friends[index];

              return FriendCard(
                friend: friend,
                assetPath: AppAssets.deleteIc,
                onPressed: () {
                  context.read<FriendsRemoteBloc>().add(
                    RemoveFriend(friendId: friend.uid!),
                  );
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _FriendsErrorView extends StatelessWidget {
  const _FriendsErrorView({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) {
    return Center(child: Text('${context.locale.errorPrefix} $message'));
  }
}

class _FriendsEmptyView extends StatelessWidget {
  const _FriendsEmptyView();

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.person_off, size: 64, color: context.appColors.slate),
        const SizedBox(height: 16),
        Text(
          context.locale.noFriendsYet,
          style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
            color: context.appColors.slate,
          ),
        ),
      ],
    );
  }
}
