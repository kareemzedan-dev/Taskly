import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/attachments/presentation/manager/download_attachments_view_model/download_attachments_states.dart';
import 'package:taskly/features/attachments/presentation/manager/download_attachments_view_model/download_attachments_view_model.dart';
import 'package:taskly/features/messages/presentation/manager/get_messages_view_model/get_messages_view_model_states.dart';
import 'package:taskly/features/shared/presentation/views/widgets/admin_message_card.dart';
import 'package:taskly/features/shared/presentation/views/widgets/chat_input_field.dart';
import 'package:taskly/features/shared/presentation/views/widgets/message_bubble.dart';
import 'package:taskly/features/shared/presentation/views/widgets/order_status_card.dart';

import '../../../../../core/di/di.dart';
import '../../../../client/presentation/views/tabs/my_jobs/presentation/views/pdf_viewer_view.dart';
import '../../../../messages/presentation/manager/get_messages_view_model/get_messages_view_model.dart';
import '../../../domain/entities/order_entity/order_entity.dart';

class ChatViewBody extends StatefulWidget {
  final OrderEntity order;
  final String currentUserId;
  final String receiverId;

  const ChatViewBody({
    super.key,
    required this.order,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetMessagesViewModel(getIt())
        ..getOrderMessages(widget.order.id)
        ..subscribeToMessages(widget.order.id),
      child: Column(
        children: [
          OrderStatusCard(
            price: widget.order.budget ?? 0,
            status: widget.order.status.name,
            onButtonPressed: () {},
          ),

          Expanded(
            child: BlocConsumer<GetMessagesViewModel, GetMessagesViewModelStates>(
              listener: (context, state) {
                if (state is GetMessagesViewModelStatesSuccess) {

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }
              },
              builder: (context, state) {
                if (state is GetMessagesViewModelStatesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetMessagesViewModelStatesError) {
                  return Center(child: Text("Error: ${state.failure}"));
                } else if (state is GetMessagesViewModelStatesSuccess) {
                  final messages = state.messages;

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isCurrentUser = msg.senderId == widget.currentUserId;

                      return Column(
                        crossAxisAlignment: isCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (msg.messageType == "text") ...[
                            MessageBubble(
                              sender: isCurrentUser
                                  ? SenderType.freelancer
                                  : SenderType.client,
                              message: msg.content ?? "",
                              avatarUrl: Assets.assetsImagesPortraitHappySmileyMan,
                              time:
                              "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
                            ),
                          ] else if (msg.messageType == "image" && msg.attachment != null && msg.attachment!.isNotEmpty) ...[
                            GestureDetector(
                              onTap: () {
                                // تفتح الصورة في شاشة كاملة
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    child: Image.network(msg.attachment!.first.url),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  msg.attachment!.first.url,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ] else if (msg.messageType == "file" && msg.attachment != null && msg.attachment!.isNotEmpty) ...[
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 4.h),
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: Colors.grey.shade300, width: 1),
                              ),
                              width: 220.w, // ✅ مش واخد الشاشة كلها
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: Colors.blue,
                                    size: 20.sp, // ✅ Responsive
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      msg.attachment!.first.name ?? "Attachment",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),

                                  // 👁 أيقونة العرض
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.orange,
                                      size: 20.sp,
                                    ),
                                    onPressed: () {
                                 Navigator.push(context, MaterialPageRoute(builder: (context) {
                                   return FileViewerView(
                                    filePath: msg.attachment!.first.url,
                                     isNetwork: true,
                                   );
                                 },));
                                    },
                                  ),


                                  IconButton(
                                    icon: Icon(
                                      Icons.download,
                                      color: Colors.green,
                                      size: 20.sp,
                                    ),
                                    onPressed: () {
                                      context.read<DownloadAttachmentsViewModel>().downloadAttachments(
                                        msg.attachment!.first.url,
                                        msg.attachment!.first.name ?? "attachment",
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )

                          ],
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
            orderId: widget.order.id,
            currentUserId: widget.currentUserId,
            receiverId: widget.receiverId,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
