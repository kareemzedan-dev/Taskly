// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:taskly/core/di/di.dart';
// import 'package:taskly/features/messages/presentation/widgets/attachment_button.dart';
// import 'package:taskly/features/messages/presentation/widgets/message_input_field.dart';
// import 'package:taskly/features/messages/presentation/widgets/send_record_button.dart';
// import 'package:uuid/uuid.dart';
// import '../../../attachments/data/models/attachments_dm/attachments_dm.dart';
// import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
// import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model_states.dart';
// import '../../data/models/message_model.dart';
// import '../../data/models/pending_message_model/pending_message_model.dart';
// import '../manager/chat_input_view_model/chat_input_view_model.dart';
// import '../manager/pending_messages_view_model/pending_messages_view_model.dart';
// import '../manager/send_to_admin_messages_view_model/send_to_admin_messages_view_model.dart';
// import '../manager/send_to_admin_messages_view_model/send_to_admin_messages_states.dart';
// import 'chat_messages_list.dart';
//
// class AdminChatInputField extends StatefulWidget {
//   final String currentUserId;
//   final String receiverAdminId;
//   final String currentUserRole;
//   final String receiverUserRole;
//   final VoidCallback? onMessageSent;
//
//   const AdminChatInputField({
//     super.key,
//     required this.currentUserId,
//     required this.receiverAdminId,
//     required this.currentUserRole,
//     required this.receiverUserRole,
//     this.onMessageSent,
//   });
//
//   @override
//   State<AdminChatInputField> createState() => _AdminChatInputFieldState();
// }
//
// class _AdminChatInputFieldState extends State<AdminChatInputField> {
//   late final ChatInputViewModel _viewModel;
//
//   @override
//   void initState() {
//     super.initState();
//     _viewModel = getIt<ChatInputViewModel>();
//   }
//
//   void _sendTextMessage() async {
//     final text = _viewModel.textController.text.trim();
//     if (text.isEmpty) return;
//
//     final messageId = _addPendingTextMessage(text);
//
//     final sendVm = context.read<SendToAdminMessagesViewModel>();
//     final now = DateTime.now();
//
//     await sendVm.SendToAdminMessage(
//       message: MessageModel(
//         id: Uuid().v4(),
//         senderId: widget.currentUserId,
//         receiverId: widget.receiverAdminId,
//         messageType: 'text',
//         content: text,
//         status: 'pending',
//         createdAt: now,
//         updatedAt: now,
//         senderType: widget.currentUserRole,
//         receiverType: 'admin',
//       ),
//     );
//
//     _viewModel.textController.clear();
//     _removePendingMessage(messageId);
//     widget.onMessageSent?.call();
//   }
//
//   Future<void> _startOrStopRecording() async {
//     await _viewModel.startOrStopRecording(
//       context: context,
//       orderId: null,
//       currentUserId: widget.currentUserId,
//       receiverId: widget.receiverAdminId,
//       senderType: widget.currentUserRole,
//       receiverType: widget.receiverUserRole,
//       onMessageSent: widget.onMessageSent,
//       onRecordingStarted: _addPendingVoiceMessage,
//       onRecordingStopped: (String? audioPath) {
//         if (audioPath != null) _updatePendingVoiceMessageWithFile(audioPath);
//       },
//       onUploadSuccess: (String messageId) {
//         Future.delayed(const Duration(seconds: 2), () => _removePendingMessage(messageId));
//       },
//       onUploadError: _updatePendingMessageError,
//     );
//   }
//
//   void _handleAttachmentUpload(List<AttachmentModel> attachments) {
//     if (attachments.isEmpty) return;
//
//     for (final att in attachments) {
//       final messageId = _addPendingFileMessage(att);
//
//
//     }
//   }
//
//   // ===================== Pending Messages Helpers =====================
//   String _addPendingTextMessage(String text) {
//     final id = Uuid().v4();
//     final msg = PendingMessage(
//       id: id,
//       content: text,
//       type: MessagesType.text,
//       createdAt: DateTime.now(),
//       isCurrentUser: true,
//       uploadProgress: 0,
//     );
//     context.read<PendingMessagesViewModel>().addPendingMessage(msg);
//     widget.onMessageSent?.call();
//     return id;
//   }
//
//   String _addPendingVoiceMessage() {
//     final id = Uuid().v4();
//     final msg = PendingMessage(
//       id: id,
//       content: 'رسالة صوتية',
//       type: MessagesType.audio,
//       createdAt: DateTime.now(),
//       isCurrentUser: true,
//       uploadProgress: 0,
//     );
//     context.read<PendingMessagesViewModel>().addPendingMessage(msg);
//     widget.onMessageSent?.call();
//     return id;
//   }
//
//   String _addPendingFileMessage(AttachmentModel att) {
//     final id = Uuid().v4();
//     final msg = PendingMessage(
//       id: id,
//       content: att.name,
//       type: MessagesType.file,
//       createdAt: DateTime.now(),
//       isCurrentUser: true,
//       filePath: att.storagePath,
//       uploadProgress: 0,
//     );
//     context.read<PendingMessagesViewModel>().addPendingMessage(msg);
//     widget.onMessageSent?.call();
//     return id;
//   }
//
//   void _updatePendingMessageProgress(String id, double progress) {
//     context.read<PendingMessagesViewModel>().updateUploadProgress(id, progress);
//   }
//
//   void _updatePendingMessageWithFileUrl(String id, String url) {
//     context.read<PendingMessagesViewModel>().updateMessageWithFileUrl(id, url);
//   }
//
//   void _updatePendingVoiceMessageWithFile(String path) {
//     final voiceMsg = context
//         .read<PendingMessagesViewModel>()
//         .pendingMessages
//         .lastWhere((m) => m.id.startsWith('voice_'));
//     context.read<PendingMessagesViewModel>().updateMessageWithFileUrl(voiceMsg.id, path);
//   }
//
//   void _removePendingMessage(String id) {
//     context.read<PendingMessagesViewModel>().removePendingMessage(id);
//   }
//
//   void _updatePendingMessageError(String id) {
//     context.read<PendingMessagesViewModel>().updateUploadProgress(id, 0);
//   }
//
//   // ===================== UI =====================
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider.value(
//       value: _viewModel,
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: getIt<SendToAdminMessagesViewModel>()),
//           BlocProvider.value(value: getIt<UploadAttachmentsViewModel>()),
//         ],
//         child: MultiBlocListener(
//           listeners: [
//             BlocListener<SendToAdminMessagesViewModel, SendToAdminMessagesStates>(
//               listener: (context, state) {
//                 if (state is SendToAdminMessagesErrorState) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to send message: ${state.message}'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//             ),
//             BlocListener<UploadAttachmentsViewModel, UploadAttachmentsViewModelStates>(
//               listener: (context, state) {
//                 if (state is UploadAttachmentsViewModelStatesSuccess) {
//                   final attachments = state.attachments.map((e) => AttachmentModel.fromEntity(e)).toList();
//                   _handleAttachmentUpload(attachments);
//                 }
//               },
//             ),
//           ],
//           child: Consumer<ChatInputViewModel>(
//             builder: (context, vm, child) {
//               return Container(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom + 10.h,
//                   left: 12.w,
//                   right: 12.w,
//                   top: 8.h,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
//                 ),
//                 child: Row(
//                   children: [
//                     AttachmentButton(onPressed: () async {
//                       await context.read<UploadAttachmentsViewModel>().pickFilesFromDevice(bucketName: "attachments", singleFileMode: true);
//                     }),
//                     SizedBox(width: 8.w),
//                     Expanded(
//                       child: MessageInputField(
//                         controller: vm.textController,
//                         onChanged: (value) => vm.updateTyping(value.trim().isNotEmpty),
//                         isTyping: vm.isTyping,
//                       ),
//                     ),
//                     SizedBox(width: 8.w),
//                     SendRecordButton(
//                       isTyping: vm.isTyping,
//                       isSending: vm.isSending,
//                       isRecording: vm.isRecording,
//                       onSendText: _sendTextMessage,
//                       onStartStopRecord: _startOrStopRecording,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
