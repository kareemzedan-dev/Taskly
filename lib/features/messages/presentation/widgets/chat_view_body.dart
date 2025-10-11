import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../../../core/utils/colors_manger.dart';
import '../../../shared/presentation/views/widgets/message_bubble.dart';
import '../../domain/entities/message_entity.dart';
import '../../../../../../../../../features/attachments/domain/entities/attachment_entity/attaachments_entity.dart';

import '../manager/messages_view_model/messages_view_model.dart';
 import '../manager/messages_view_model/messages_view_model_states.dart';
import '../manager/send_message_view_model/send_message_view_model.dart';
import '../manager/send_message_view_model/send_message_view_model_states.dart';
import 'chat_input_field.dart';

class ChatViewBody extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String orderId;
  final String currentUserAvatar;
  final String receiverAvatar;

  const ChatViewBody({
    super.key,
    required this.currentUserId,
    required this.receiverId,
    required this.orderId,
    required this.currentUserAvatar,
    required this.receiverAvatar,
  });

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingUrl;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() => _currentlyPlayingUrl = null);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildAttachmentWidget(AttachmentEntity att, bool isCurrentUser, bool isTemporary) {
    final isImage = att.type.startsWith("image/");
    final isPDF = att.type == "application/pdf";
    final isAudio = att.type.startsWith("audio/") || att.type == "application/octet-stream";

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          width: 250,
          decoration: BoxDecoration(
            color: isCurrentUser
                ? Colors.blue.withOpacity(0.05)
                : Colors.green.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrentUser ? Colors.blueAccent : Colors.greenAccent,
              width: isTemporary ? 0.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.blue : Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isImage
                      ? Icons.image
                      : isPDF
                      ? Icons.picture_as_pdf
                      : Icons.audiotrack,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: !isAudio
                      ? () async {
                    if (isImage) {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.all(20),
                          child: Stack(
                            children: [
                              InteractiveViewer(
                                child: Image.network(att.url, fit: BoxFit.contain),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (isPDF) {
                      launchUrl(Uri.parse(att.url));
                    }
                  }
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        att.name ?? "Attachment",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isImage
                            ? "Image"
                            : isPDF
                            ? "PDF Document"
                            : "Audio File",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              if (isAudio)
                IconButton(
                  icon: Icon(
                    _currentlyPlayingUrl == att.url ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.orange,
                    size: 28,
                  ),
                  onPressed: () async {
                    if (_currentlyPlayingUrl == att.url) {
                      await _audioPlayer.pause();
                      setState(() => _currentlyPlayingUrl = null);
                    } else {
                      await _audioPlayer.stop();
                      await _audioPlayer.play(UrlSource(att.url));
                      setState(() => _currentlyPlayingUrl = att.url);
                    }
                  },
                ),
            ],
          ),
        ),
        if (isTemporary)
          const Positioned(
            top: 4,
            right: 4,
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<MessagesViewModel>()..loadAndSubscribe(widget.orderId),
        ),
        BlocProvider(
          create: (_) => getIt<SendMessageViewModel>(),
        ),
      ],
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<MessagesViewModel, MessagesStates>(
              listener: (context, state) {
                if (state is MessagesSuccess) _scrollToBottom();
              },
              builder: (context, state) {
                if (state is MessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessagesError) {
                  return Center(
                    child: Text(
                      "Error: ${state.failure.message}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is MessagesSuccess) {
                  final messages = state.messages;

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text("No messages yet", style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isCurrentUser = msg.senderId == widget.currentUserId;

                      return Column(
                        crossAxisAlignment:
                        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (msg.messageType == "text" && (msg.content?.isNotEmpty ?? false))
                            MessageBubble(
                              avatarUrl: isCurrentUser
                                  ? widget.currentUserAvatar
                                  : widget.receiverAvatar,
                              sender: isCurrentUser
                                  ? SenderType.freelancer
                                  : SenderType.client,
                              message: msg.content ?? "",
                              chatWithUsers: true,
                              time:
                              "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
                            ),

                          if (msg.attachment != null)
                            ...msg.attachment!.map(
                                  (att) => _buildAttachmentWidget(att, isCurrentUser, false),
                            ),
                          SizedBox(height: 12.h),
                        ],
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          ChatInputField(
            orderId: widget.orderId,
            currentUserId: widget.currentUserId,
            receiverId: widget.receiverId,
            currentUserRole: "client_or_freelancer", // تقدر تحددها حسب الحالة
            receiverUserRole: "opposite_role",
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
