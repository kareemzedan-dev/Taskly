// chat/presentation/widgets/chat_messages_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/features/messages/presentation/widgets/message_shimmer.dart';
import 'package:taskly/features/messages/presentation/manager/get_messages_view_model/get_messages_view_model.dart';
import 'package:taskly/features/messages/presentation/manager/get_messages_view_model/get_messages_view_model_states.dart';
import 'package:taskly/features/shared/presentation/views/widgets/message_bubble.dart';

import '../manager/subscribe_to_messages_view_model/subscribe_to_messages_states.dart';
import '../manager/subscribe_to_messages_view_model/subscribe_to_messages_view_model.dart';

class ChatMessagesList extends StatelessWidget {
  final String currentUserId;
  final ScrollController scrollController;
  final String? freelancerAvatar;
  final String? clientAvatar;

  const ChatMessagesList({
    super.key,
    required this.currentUserId,
    required this.scrollController,
    required this.freelancerAvatar,
    required this.clientAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetMessagesViewModel, GetMessagesViewModelStates>(
      builder: (context, oldState) {
        List messages = [];
        if (oldState is GetMessagesViewModelStatesLoading) {
          return const MessageShimmer();
        }
        if (oldState is GetMessagesViewModelStatesSuccess) {
          messages = oldState.messages;
        }

        return BlocBuilder<SubscribeToMessagesViewModel,
            SubscribeToMessagesStates>(
          builder: (context, newState) {
            if (newState is SubscribeToMessagesStatesSuccess) {
              for (var msg in newState.messages) {
                if (!messages.any((m) => m.id == msg.id)) {
                  messages.add(msg);
                }
              }
            }

            return ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isCurrentUser = msg.senderId == currentUserId;

                return MessageBubble(
                  sender:
                      isCurrentUser ? SenderType.freelancer : SenderType.client,
                  message: msg.content ?? "",
                  avatarUrl: isCurrentUser
                      ? freelancerAvatar ?? ""
                      : clientAvatar ?? "",
                  time:
                      "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
                  type: _getMessageType(msg.messageType),
                  fileUrl:
                      (msg.attachment != null && msg.attachment!.isNotEmpty)
                          ? msg.attachment!.first.url
                          : null,
                );
              },
            );
          },
        );
      },
    );
  }
}

MessageType _getMessageType(String type) {
  switch (type) {
    case 'voice':
      return MessageType.audio;
    case 'file':
      return MessageType.file;
    default:
      return MessageType.text;
  }
}
