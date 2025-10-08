import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/features/messages/presentation/widgets/attachment_button.dart';
import 'package:taskly/features/messages/presentation/widgets/message_input_field.dart';
import 'package:taskly/features/messages/presentation/widgets/send_record_button.dart';
import '../../../attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model_states.dart';
import '../manager/chat_input_view_model/chat_input_view_model.dart';
import '../manager/send_message_view_model/send_message_view_model.dart';
import '../manager/send_message_view_model/send_message_view_model_states.dart';

class ChatInputField extends StatefulWidget {
  final String? orderId;
  final String currentUserId;
  final String receiverId;
  final String currentUserRole;
  final String receiverUserRole;
  final VoidCallback? onMessageSent;

  const ChatInputField({
    super.key,
    this.orderId,
    required this.currentUserId,
    required this.receiverId,
    required this.currentUserRole,
    required this.receiverUserRole,
    this.onMessageSent,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late final ChatInputViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChatInputViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _sendTextMessage() {
    _viewModel.sendTextMessage(
      context: context,
      orderId: widget.orderId,
      currentUserId: widget.currentUserId,
      receiverId: widget.receiverId,
      senderType: widget.currentUserRole,
      receiverType: widget.receiverUserRole,
      onMessageSent: widget.onMessageSent,
    );
  }

  Future<void> _startOrStopRecording() async {
    await _viewModel.startOrStopRecording(
      context: context,
      orderId: widget.orderId,
      currentUserId: widget.currentUserId,
      receiverId: widget.receiverId,
      senderType: widget.currentUserRole,
      receiverType: widget.receiverUserRole,
      onMessageSent: widget.onMessageSent,
    );
  }

  void _handleAttachmentUpload(List<AttachmentModel> attachments) {
    _viewModel.handleAttachmentUpload(
      attachments: attachments,
      context: context,
      orderId: widget.orderId,
      currentUserId: widget.currentUserId,
      receiverId: widget.receiverId,
      senderType: widget.currentUserRole,
      receiverType: widget.receiverUserRole,
      onMessageSent: widget.onMessageSent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: getIt<SendMessageViewModel>()),
          BlocProvider.value(value: getIt<UploadAttachmentsViewModel>()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<SendMessageViewModel, SendMessageViewModelStates>(
              listener: (context, state) {
                if (state is SendMessageViewModelStatesError) {
                  context.read<ChatInputViewModel>().updateSending(false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to send message: ${state.failure}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            BlocListener<UploadAttachmentsViewModel, UploadAttachmentsViewModelStates>(
              listener: (context, state) {
                if (state is UploadAttachmentsViewModelStatesSuccess) {
                  final attachments = state.attachments
                      .map((e) => AttachmentModel.fromEntity(e))
                      .toList();
                  _handleAttachmentUpload(attachments);
                } else if (state is UploadAttachmentsViewModelStatesError) {
                  context.read<ChatInputViewModel>().updateSending(false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Upload failed: ${state.message}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
          child: Consumer<ChatInputViewModel>(
            builder: (context, viewModel, child) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10.h,
                  left: 12.w,
                  right: 12.w,
                  top: 8.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AttachmentButton(
                      onPressed: () async {
                        await context.read<UploadAttachmentsViewModel>().pickFilesFromDevice(
                          bucketName: "attachments",
                          singleFileMode: true,
                        );
                      },
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: MessageInputField(
                        controller: viewModel.textController,
                        onChanged: (value) => viewModel.updateTyping(value.trim().isNotEmpty),
                        isTyping: viewModel.isTyping,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SendRecordButton(
                      isTyping: viewModel.isTyping,
                      isSending: viewModel.isSending,
                      isRecording: viewModel.isRecording,
                      onSendText: _sendTextMessage,
                      onStartStopRecord: _startOrStopRecording,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}