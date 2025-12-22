import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/asset_constants.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/auth/presentation/widgets/form_text_field.dart';
import 'package:routiner/feature/profile/presentation/bloc/friend_remote_bloc/friend_remote_bloc.dart';
import 'package:routiner/feature/profile/presentation/widgets/friend_card.dart';

class AddFriendDialog extends StatelessWidget {
  const AddFriendDialog({super.key});

  @override
  Widget build(final BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return BlocListener<FriendsRemoteBloc, FriendsRemoteState>(
      listener: (final BuildContext context, final FriendsRemoteState state) {
        if (state is FriendAdded) {
          context.read<FriendsRemoteBloc>().add(LoadFriends());
          searchController.clear();
        }
      },
      child: AlertDialog(
        backgroundColor: context.appColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: Text(context.locale.addFriendTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /// 🔍 Search field
              FormTextField(
                controller: searchController,
                onChanged: (final String value) {
                  context.read<FriendsRemoteBloc>().add(
                    SearchUsers(query: value),
                  );
                },
              ),
              const SizedBox(height: 16),

              /// 📋 Search results
              Expanded(
                child: BlocBuilder<FriendsRemoteBloc, FriendsRemoteState>(
                  builder:
                      (
                        final BuildContext context,
                        final FriendsRemoteState state,
                      ) {
                        if (state is SearchLoading ||
                            state is FriendActionLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is SearchError) {
                          return Center(
                            child: Text(
                              '${context.locale.errorPrefix} ${state.message}',
                            ),
                          );
                        }

                        if (state is SearchLoaded) {
                          if (state.searchResults.isEmpty) {
                            return Center(
                              child: Text(context.locale.noUsersFound),
                            );
                          }

                          return ListView.builder(
                            itemCount: state.searchResults.length,
                            itemBuilder:
                                (final BuildContext context, final int index) {
                                  final UserEntity user =
                                      state.searchResults[index];

                                  return FriendCard(
                                    friend: user,
                                    assetPath: AppAssets.addButtonIc,
                                    onPressed: () {
                                      context.read<FriendsRemoteBloc>().add(
                                        AddFriend(friendId: user.uid!),
                                      );
                                    },
                                  );
                                },
                          );
                        }

                        if (state is FriendAdded) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                color: context.appColors.c3BA935,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              Text(context.locale.friendAddedSuccess),
                            ],
                          );
                        }

                        return Center(child: Text(context.locale.searchPrompt));
                      },
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.router.pop(),
            child: Text(context.locale.close),
          ),
        ],
      ),
    );
  }
}
