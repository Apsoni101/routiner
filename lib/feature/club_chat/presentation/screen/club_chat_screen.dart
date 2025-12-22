import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/auth/presentation/widgets/form_text_field.dart';
import 'package:routiner/feature/club_chat/domain/entity/club_message_entity.dart';
import 'package:routiner/feature/club_chat/presentation/bloc/club_chat_bloc/club_chat_bloc.dart';
import 'package:routiner/feature/club_chat/presentation/widgets/members_bottom_sheet.dart';
import 'package:routiner/feature/common/presentation/widgets/custom_app_bar.dart';
import 'package:routiner/feature/home/domain/entity/club_entity.dart';

@RoutePage()
class ClubChatScreen extends StatefulWidget {
  const ClubChatScreen({
    required this.club,
    required this.currentUserId,
    required this.onMemberRemoved,
    required this.onLeaveClub,
    super.key,
  });

  final ClubEntity club;
  final String currentUserId;
  final void Function(String userId) onMemberRemoved;
  final VoidCallback onLeaveClub;

  @override
  State<ClubChatScreen> createState() => _ClubChatScreenState();
}

class _ClubChatScreenState extends State<ClubChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final ClubChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = AppInjector.getIt<ClubChatBloc>();
    _chatBloc.add(LoadMessagesEvent(widget.club.id));
  }

  @override
  void dispose() {
    _chatBloc.close();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final bool isCreator = widget.club.isCreator(widget.currentUserId);

    return BlocProvider<ClubChatBloc>.value(
      value: _chatBloc,
      child: Scaffold(
        backgroundColor: context.appColors.cEAECF0,
        appBar: CustomAppBar(
          title: widget.club.name,
          subtitle: '${widget.club.memberIds.length} ${context.locale.members}',
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () => _showMembersBottomSheet(context, isCreator),
            ),
            if (!isCreator)
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () => _leaveClub(context),
              ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _ChatMessagesSection(currentUserId: widget.currentUserId),
            ),
            _MessageInput(controller: _messageController, onSend: _sendMessage),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final String message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }

    _chatBloc.add(SendMessageEvent(clubId: widget.club.id, message: message));
    _messageController.clear();
  }

  void _showMembersBottomSheet(
      final BuildContext context,
      final bool isCreator,
      ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider<ClubChatBloc>.value(
        value: _chatBloc,
        child: MembersBottomSheet(
          club: widget.club,
          currentUserId: widget.currentUserId,
          isCreator: isCreator,
          onMemberRemoved: widget.onMemberRemoved,
        ),
      ),
    );
  }

  void _leaveClub(final BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.locale.leaveClubTitle),
        content: Text(context.locale.leaveClubMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.router.pop(),
            child: Text(context.locale.leave),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onLeaveClub();
              context.router.pop();
              context.router.pop();
            },
            child: Text(context.locale.leave),
          ),
        ],
      ),
    );
  }
}

class _ChatMessagesSection extends StatelessWidget {
  const _ChatMessagesSection({required this.currentUserId});

  final String currentUserId;

  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<ClubChatBloc, ClubChatState>(
      listener: (final BuildContext context, final ClubChatState state) {
        if (state is ClubChatLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: context.appColors.red,
            ),
          );
        }
      },
      builder: (final BuildContext context, final ClubChatState state) {
        if (state is ClubChatLoaded) {
          if (state.isLoadingMessages && state.messages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.messages.isEmpty && !state.isLoadingMessages) {
            return Center(child: Text(context.locale.noMessagesYet));
          }

          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(16),
            itemCount: state.messages.length,
            itemBuilder: (_, final int index) {
              final ClubMessageEntity message = state.messages[index];
              return _ChatBubble(
                message: message,
                isMe: message.senderId == currentUserId,
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.isMe});

  final ClubMessageEntity message;
  final bool isMe;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          if (!isMe)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                message.senderName,
                style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                  color: context.appColors.slate,
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? context.appColors.c000DFF.withValues(alpha: 0.8)
                  : context.appColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.message,
              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0.copyWith(
                color: isMe ? context.appColors.white : context.appColors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: AppTextStyles.airbnbCerealW400S12Lh16.copyWith(
                fontSize: 10,
                color: context.appColors.black.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ClubChatBloc, ClubChatState>(
      builder: (final BuildContext context, final ClubChatState state) {
        final bool isSending = state is ClubChatLoaded && state.isLoadingMessages;

        return Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: FormTextField(
                  controller: controller,
                  enabled: !isSending,
                  hintText: context.locale.typeMessageHint,
                  onSubmitted: (_) => onSend(),
                ),
              ),
              IconButton(
                icon: isSending
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : const Icon(Icons.send),
                onPressed: isSending ? null : onSend,
              ),
            ],
          ),
        );
      },
    );
  }
}