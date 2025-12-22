import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_colors.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/localization_extension.dart';

import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/club_chat/presentation/bloc/club_chat_bloc/club_chat_bloc.dart';
import 'package:routiner/feature/common/presentation/widgets/wave_bottom_sheet.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';
import 'package:routiner/feature/home/presentation/widgets/home_tabs.dart';

class MembersBottomSheet extends StatefulWidget {
  const MembersBottomSheet({
    required this.club,
    required this.currentUserId,
    required this.isCreator,
    required this.onMemberRemoved,
    super.key,
  });

  final ClubEntity club;
  final String currentUserId;
  final bool isCreator;
  final void Function(String userId) onMemberRemoved;

  @override
  State<MembersBottomSheet> createState() => _MembersBottomSheetState();
}

class _MembersBottomSheetState extends State<MembersBottomSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.isCreator ? 2 : 1,
      vsync: this,
    );

    context.read<ClubChatBloc>().add(LoadMembersEvent(widget.club.id));
    if (widget.isCreator) {
      context.read<ClubChatBloc>().add(
        LoadPendingRequestsEvent(widget.club.id),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: (_, final ScrollController scrollController) {
        return CommonWaveBottomSheet(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 28),
              if (widget.isCreator)
                HomeTabs(
                  controller: _tabController,
                  tabs: <String>[
                    context.locale.membersCount(widget.club.memberIds.length),
                    context.locale.requestsTab,
                  ],
                  onTabChanged: (final int index) {},
                ),
              const SizedBox(height: 20),
              Expanded(
                child: _MembersTabView(
                  controller: _tabController,
                  isCreator: widget.isCreator,
                  club: widget.club,
                  currentUserId: widget.currentUserId,
                  onMemberRemoved: widget.onMemberRemoved,
                  scrollController: scrollController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MembersTabView extends StatelessWidget {
  const _MembersTabView({
    required this.controller,
    required this.isCreator,
    required this.club,
    required this.currentUserId,
    required this.onMemberRemoved,
    required this.scrollController,
  });

  final TabController controller;
  final bool isCreator;
  final ClubEntity club;
  final String currentUserId;
  final void Function(String userId) onMemberRemoved;
  final ScrollController scrollController;

  @override
  Widget build(final BuildContext context) {
    if (!isCreator) {
      return _MembersList(
        club: club,
        currentUserId: currentUserId,
        onMemberRemoved: onMemberRemoved,
        scrollController: scrollController,
      );
    }

    return TabBarView(
      controller: controller,
      children: <Widget>[
        _MembersList(
          club: club,
          currentUserId: currentUserId,
          onMemberRemoved: onMemberRemoved,
          scrollController: scrollController,
        ),
        _PendingRequestsList(
          clubId: club.id,
          scrollController: scrollController,
        ),
      ],
    );
  }
}

class _MembersList extends StatelessWidget {
  const _MembersList({
    required this.club,
    required this.currentUserId,
    required this.onMemberRemoved,
    required this.scrollController,
  });

  final ClubEntity club;
  final String currentUserId;
  final void Function(String userId) onMemberRemoved;
  final ScrollController scrollController;

  @override
  Widget build(final BuildContext context) {
    final AppThemeColors colors = Theme.of(
      context,
    ).extension<AppThemeColors>()!;

    return BlocBuilder<ClubChatBloc, ClubChatState>(
      builder: (_, final ClubChatState state) {
        if (state is ClubChatLoaded) {
          if (state.isLoadingMembers && state.members.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: colors.primaryBlue),
            );
          }

          if (state.members.isEmpty && !state.isLoadingMembers) {
            return Center(
              child: Text(
                context.locale.noMembersFound,
                style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
                  color: colors.slate,
                ),
              ),
            );
          }

          return ListView.builder(
            controller: scrollController,
            itemCount: state.members.length,
            itemBuilder: (_, final int index) {
              final UserEntity member = state.members[index];
              return ListTile(
                title: Text(
                  '${member.name} ${member.surname}',
                  style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                    color: colors.black,
                  ),
                ),
                subtitle: Text(
                  member.email ?? '',
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: colors.slate,
                  ),
                ),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(color: colors.primaryBlue),
        );
      },
    );
  }
}

class _PendingRequestsList extends StatelessWidget {
  const _PendingRequestsList({
    required this.clubId,
    required this.scrollController,
  });

  final String clubId;
  final ScrollController scrollController;

  void _acceptRequest(final BuildContext context, final UserEntity user) {
    context.read<ClubChatBloc>().add(
      AcceptJoinRequestEvent(clubId: clubId, userId: user.uid ?? ''),
    );
  }

  void _rejectRequest(final BuildContext context, final UserEntity user) {
    final AppThemeColors colors = Theme.of(
      context,
    ).extension<AppThemeColors>()!;

    showDialog<void>(
      context: context,
      builder: (final BuildContext dialogContext) => AlertDialog(
        title: Text(
          context.locale.rejectRequestTitle,
          style: AppTextStyles.airbnbCerealW500S18Lh24Ls0.copyWith(
            color: colors.black,
          ),
        ),
        content: Text(
          context.locale.rejectRequestMessage(user.name ?? ''),
          style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
            color: colors.darkGrey,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.locale.cancel,
              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                color: colors.primaryBlue,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ClubChatBloc>().add(
                RejectJoinRequestEvent(clubId: clubId, userId: user.uid ?? ''),
              );
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: colors.red),
            child: Text(
              context.locale.reject,
              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                color: colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final AppThemeColors colors = Theme.of(
      context,
    ).extension<AppThemeColors>()!;

    return BlocConsumer<ClubChatBloc, ClubChatState>(
      listenWhen: (final ClubChatState previous, final ClubChatState current) {
        if (current is ClubChatLoaded && previous is ClubChatLoaded) {
          return current.successMessage != previous.successMessage ||
              current.errorMessage != previous.errorMessage;
        }
        return false;
      },
      listener: (final BuildContext context, final ClubChatState state) {
        if (state is ClubChatLoaded) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
            context.read<ClubChatBloc>().add(LoadMembersEvent(clubId));
            context.read<ClubChatBloc>().add(LoadPendingRequestsEvent(clubId));
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: colors.red,
              ),
            );
          }
        }
      },
      builder: (_, final ClubChatState state) {
        if (state is ClubChatLoaded) {
          if (state.isLoadingRequests && state.pendingUsers.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: colors.primaryBlue),
            );
          }

          if (state.pendingUsers.isEmpty && !state.isLoadingRequests) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.inbox, size: 64, color: colors.slate),
                  const SizedBox(height: 16),
                  Text(
                    context.locale.noPendingRequests,
                    style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
                      color: colors.slate,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: scrollController,
            itemCount: state.pendingUsers.length,
            itemBuilder: (_, final int index) {
              final UserEntity user = state.pendingUsers[index];
              return ListTile(
                title: Text(
                  '${user.name} ${user.surname}',
                  style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                    color: colors.black,
                  ),
                ),
                subtitle: Text(
                  user.email ?? '',
                  style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                    color: colors.slate,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.check_circle, color: colors.c22C55E),
                      onPressed: () => _acceptRequest(context, user),
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: colors.red),
                      onPressed: () => _rejectRequest(context, user),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return Center(
          child: Text(
            context.locale.unableToLoadRequests,
            style: AppTextStyles.airbnbCerealW400S14Lh20Ls0.copyWith(
              color: colors.slate,
            ),
          ),
        );
      },
    );
  }
}
