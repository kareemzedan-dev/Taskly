import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/messages/presentation/widgets/message_shimmer.dart';
import 'package:taskly/features/messages/presentation/widgets/chat_input_field.dart';
import 'package:taskly/core/di/di.dart';
import '../../../shared/presentation/views/widgets/message_bubble.dart';
import '../manager/get_admin_messages_view_model/get_admin_messages_states.dart';
import '../manager/get_admin_messages_view_model/get_admin_messages_view_model.dart';
import '../manager/subscribe_to_admin_messages_view_model/subscribe_to_admin_messages_states.dart';
import '../manager/subscribe_to_admin_messages_view_model/subscribe_to_admin_messages_view_model.dart';

class ChatWithAdminViewBody extends StatefulWidget {
  final String currentUserId;

  const ChatWithAdminViewBody({super.key, required this.currentUserId});

  @override
  State<ChatWithAdminViewBody> createState() => _ChatWithAdminViewBodyState();
}

class _ChatWithAdminViewBodyState extends State<ChatWithAdminViewBody> {
  final ScrollController _scrollController = ScrollController();
  final String adminAvatar = Assets.assetsUserAvatar;
  String? receiverAdminId;

  List messages = [];

  void _scrollToBottom() {
    if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    context.read<SubscribeToAdminMessagesViewModel>().unsubscribe();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
            getIt<GetAdminMessagesViewModel>()..getAdminMessages(widget.currentUserId),
          ),
          BlocProvider(
            create: (_) => getIt<SubscribeToAdminMessagesViewModel>()
              ..subscribeToAdminMessages(
                widget.currentUserId,
                    (msg, action) {
                  if (!messages.any((m) => m.id == msg.id)) {
                    setState(() => messages.add(msg));
                    _scrollToBottom();
                  }
                },
              ),
          ),
        ],
        child: Column(
          children: [
            // ✅ Messages List
            Expanded(
              child: BlocBuilder<GetAdminMessagesViewModel, GetAdminMessagesStates>(
                builder: (context, state) {
                  if (state is GetAdminMessagesLoadingState) {
                    return const MessageShimmer();
                  } else if (state is GetAdminMessagesSuccessState) {
                    messages = state.messages ?? [];
                    if (messages.isNotEmpty) {
                      receiverAdminId ??= messages.first.senderId != widget.currentUserId
                          ? messages.first.senderId
                          : messages.first.receiverId;
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                  } else if (state is GetAdminMessagesErrorState) {
                    return Center(child: Text("Error: ${state.failure}"));
                  }

                  return BlocBuilder<SubscribeToAdminMessagesViewModel, SubscribeToAdminMessagesStates>(
                    builder: (context, newState) {
                      if (newState is SubscribeToAdminMessagesSuccessState && newState.messages.isNotEmpty) {
                        for (var msg in newState.messages) {
                          if (!messages.any((m) => m.id == msg.id)) {
                            messages.add(msg);
                          }
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                      }

                      return messages.isEmpty
                          ? const Center(child: Text("No messages yet"))
                          : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isCurrentUser = msg.senderId == widget.currentUserId;
                          return MessageBubble(
                            sender: isCurrentUser ? SenderType.client : SenderType.admin,
                            message: msg.content ?? "",
                            avatarUrl: isCurrentUser ? "" : adminAvatar,
                            time:
                            "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')} ${msg.createdAt.hour < 12 ? "AM" : "PM"}",
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // Padding(
            //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            //   child: ChatInputField(
            //     orderId: null,
            //     currentUserId: widget.currentUserId,
            //     receiverId: "97ea47d8-d66b-4d44-97fe-112fc59251b0" ?? "",
            //   ),
            // ),
            SizedBox(height: 16.h),
          ],
        ),

      ),
    );
  }
}
