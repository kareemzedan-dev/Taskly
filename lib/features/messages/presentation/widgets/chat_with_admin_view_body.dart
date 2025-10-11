import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/messages/presentation/widgets/message_shimmer.dart';
import 'package:taskly/features/messages/presentation/widgets/chat_input_field.dart';
import 'package:taskly/core/di/di.dart';
import '../../../shared/presentation/views/widgets/message_bubble.dart';
import '../manager/get_admin_messages_view_model/get_admin_messages_states.dart';
import '../manager/get_admin_messages_view_model/get_admin_messages_view_model.dart';
import '../manager/subscribe_to_admin_messages_view_model/subscribe_to_admin_messages_states.dart';
import '../manager/subscribe_to_admin_messages_view_model/subscribe_to_admin_messages_view_model.dart';
import '../manager/send_to_admin_messages_view_model/send_to_admin_messages_view_model.dart';
import 'admin_chat_input_field.dart';

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
    if (_scrollController.hasClients) {
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
            create: (_) => getIt<GetAdminMessagesViewModel>()
              ..getAdminMessages(widget.currentUserId),
          ),
          BlocProvider(
            create: (_) => getIt<SubscribeToAdminMessagesViewModel>()
              ..subscribeToAdminMessages(widget.currentUserId, (msg, action) {
                if (!messages.any((m) => m.id == msg.id)) {
                  setState(() => messages.add(msg));
                  _scrollToBottom();
                }
              }),
          ),
          BlocProvider(
            create: (_) => getIt<SendToAdminMessagesViewModel>(),
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: BlocListener<GetAdminMessagesViewModel,
                  GetAdminMessagesStates>(
                listener: (context, state) {
                  if (state is GetAdminMessagesSuccessState) {
                    // دمج الرسائل القديمة مع الجديدة من subscription
                    final oldMessages = context
                        .read<SubscribeToAdminMessagesViewModel>()
                        .messages;
                    final combined = [...oldMessages, ...state.messages];
                    setState(() => messages = combined);

                    if (combined.isNotEmpty && receiverAdminId == null) {
                      receiverAdminId =
                      combined.first.senderId != widget.currentUserId
                          ? combined.first.senderId
                          : combined.first.receiverId;
                    }

                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _scrollToBottom());
                  }
                },
                child: BlocBuilder<SubscribeToAdminMessagesViewModel,
                    SubscribeToAdminMessagesStates>(
                  builder: (context, state) {
                    if (messages.isEmpty)
                      return const Center(child: Text("No messages yet"));

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isCurrentUser =
                            msg.senderId == widget.currentUserId;
                        return MessageBubble(
                          sender: isCurrentUser
                              ? SenderType.client
                              : SenderType.admin,
                          message: msg.content ?? "",
                          avatarUrl: isCurrentUser ? "" : adminAvatar,
                          time:
                          "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')} ${msg.createdAt.hour < 12 ? "AM" : "PM"}",
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: AdminChatInputField(

                currentUserId: widget.currentUserId,
                currentUserRole:
                SharedPrefHelper.getString(StringsManager.roleKey) ??
                    "client",
                receiverUserRole: "admin",
                onMessageSent: _scrollToBottom,
                receiverAdminId: receiverAdminId ??
                    "97ea47d8-d66b-4d44-97fe-112fc59251b0",
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
