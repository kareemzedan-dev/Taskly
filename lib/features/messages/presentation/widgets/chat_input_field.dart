import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/core/di/di.dart';
import '../../../attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model_states.dart';
import '../../data/models/pending_message_model/pending_message_model.dart';
import '../../domain/entities/message_entity.dart';
import '../manager/chat_input_view_model/chat_input_view_model.dart';
import '../manager/pending_messages_view_model/pending_messages_view_model.dart';
import '../manager/send_message_view_model/send_message_view_model.dart';
import 'chat_messages_list.dart';

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
  final Map<String, bool> _uploadingFiles = {};

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ChatInputViewModel>();
  }

  void _sendTextMessage() {
    final text = _viewModel.textController.text.trim();
    if (text.isEmpty) return;

    final messageId = _addPendingTextMessage(text);

    _viewModel.sendTextMessage(
      context: context,
      orderId: widget.orderId,
      currentUserId: widget.currentUserId,
      receiverId: widget.receiverId,
      senderType: widget.currentUserRole,
      receiverType: widget.receiverUserRole,
      onMessageSent: widget.onMessageSent,
      onSuccess: () => _removePendingMessage(messageId),
      onError: () => _updatePendingMessageError(messageId),
    );
  }

  void _sendPendingAttachments() {
    if (_viewModel.pendingAttachments.isEmpty) return;

    // إضافة جميع المرفقات المؤقتة كرسائل منفصلة في الـ UI
    for (final attachment in _viewModel.pendingAttachments) {
      _addPendingFileMessage(attachment);
    }

    _viewModel.sendPendingAttachments(
      context: context,
      orderId: widget.orderId,
      currentUserId: widget.currentUserId,
      receiverId: widget.receiverId,
      senderType: widget.currentUserRole,
      receiverType: widget.receiverUserRole,
      onMessageSent: widget.onMessageSent,
      onSuccess: () {
        // تنظيف القائمة بعد الإرسال الناجح
        _viewModel.clearPendingAttachments();
      },
      onError: () {
        // في حالة الخطأ، نترك المرفقات في القائمة ليتم إعادة إرسالها
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في إرسال المرفقات'),
            backgroundColor: Colors.red,
          ),
        );
      },
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
      onRecordingStarted: _addPendingVoiceMessage,
      onRecordingStopped: (audioPath) {
        if (audioPath != null) _updatePendingVoiceMessageWithFile(audioPath);
      },
      onUploadSuccess: (messageId) {
        Future.delayed(const Duration(seconds: 2), () => _removePendingMessage(messageId));
      },
      onUploadError: _updatePendingMessageError,
    );
  }

  Future<void> _handleAttachmentUpload(List<AttachmentModel> attachments) async {
    if (attachments.isEmpty) return;

    // رفع الملفات بدون إرسالها كرسائل
    await _viewModel.uploadAttachments(
      attachments: attachments,
      context: context,
      onUploadStatusChanged: (fileId, isUploading) {
        setState(() {
          if (isUploading) {
            _uploadingFiles[fileId] = true;
          } else {
            _uploadingFiles.remove(fileId);
          }
        });
      },
    );
  }

  // --- Pending messages helpers ---
  String _addPendingTextMessage(String text) {
    final messageId = 'text_${DateTime.now().millisecondsSinceEpoch}';
    final pending = PendingMessage(
      id: messageId,
      content: text,
      type: MessagesType.text,
      createdAt: DateTime.now(),
      isCurrentUser: true,
      uploadProgress: 0.0,
    );
    context.read<PendingMessagesViewModel>().addPendingMessage(pending);
    widget.onMessageSent?.call();
    return messageId;
  }

  String _addPendingVoiceMessage() {
    final messageId = 'voice_${DateTime.now().millisecondsSinceEpoch}';
    final pending = PendingMessage(
      id: messageId,
      content: 'رسالة صوتية',
      type: MessagesType.audio,
      createdAt: DateTime.now(),
      isCurrentUser: true,
      uploadProgress: 0.0,
    );
    context.read<PendingMessagesViewModel>().addPendingMessage(pending);
    widget.onMessageSent?.call();
    return messageId;
  }

  String _addPendingFileMessage(AttachmentModel attachment) {
    final messageId = 'file_${DateTime.now().millisecondsSinceEpoch}_${attachment.id}';
    final isImage = _isImageFile(attachment.name);
    final pending = PendingMessage(
      id: messageId,
      content: isImage ? '' : attachment.name,
      filePath: attachment.storagePath,
      type: isImage ? MessagesType.image : MessagesType.file,
      createdAt: DateTime.now(),
      isCurrentUser: true,
      caption: isImage ? 'صورة' : null,
      uploadProgress: 1.0, // تم الرفع بالفعل
    );
    context.read<PendingMessagesViewModel>().addPendingMessage(pending);
    widget.onMessageSent?.call();
    return messageId;
  }

  void _updatePendingVoiceMessageWithFile(String audioPath) {
    final pendingVM = context.read<PendingMessagesViewModel>();
    final pending = pendingVM.pendingMessages.lastWhere(
          (msg) => msg.id.startsWith('voice_'),
      orElse: () => pendingVM.pendingMessages.last,
    );
    pendingVM.updateMessageWithFileUrl(pending.id, audioPath);
  }

  void _updatePendingMessageError(String messageId) {
    context.read<PendingMessagesViewModel>().updateUploadProgress(messageId, 0.0);
  }

  void _removePendingMessage(String messageId) {
    context.read<PendingMessagesViewModel>().removePendingMessage(messageId);
  }

  bool _isImageFile(String name) {
    final ext = name.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(ext);
  }

  Widget _buildPendingAttachmentsPreview() {
    if (_viewModel.pendingAttachments.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.attach_file, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                '${_viewModel.pendingAttachments.length} مرفق جاهز للإرسال',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _viewModel.pendingAttachments.map((attachment) {
              final isUploading = _uploadingFiles[attachment.id] == true;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isUploading
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Icon(
                        _getFileIcon(attachment.type),
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        attachment.name,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      if (!isUploading)
                        GestureDetector(
                          onTap: () {
                            _viewModel.removePendingAttachment(attachment);
                          },
                          child: const Icon(Icons.close, size: 16, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: _viewModel.pendingAttachments.isEmpty ? null : _sendPendingAttachments,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                ),
                child: const Text('إرسال المرفقات'),
              ),
              const SizedBox(width: 8),
              if (_viewModel.pendingAttachments.isNotEmpty)
                OutlinedButton(
                  onPressed: () {
                    _viewModel.clearPendingAttachments();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('إلغاء الكل'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String? fileType) {
    if (fileType?.startsWith('image/') == true) return Icons.image;
    if (fileType?.startsWith('audio/') == true) return Icons.audiotrack;
    if (fileType == 'application/pdf') return Icons.picture_as_pdf;
    if (fileType?.contains('word') == true) return Icons.description;
    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<ChatInputViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // معاينة المرفقات المؤقتة
              _buildPendingAttachmentsPreview(),

              Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                  left: 12,
                  right: 12,
                  top: 8,
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
                    // زر المرفقات
                    Consumer<UploadAttachmentsViewModel>(
                      builder: (context, uploadVM, child) {
                        return IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () async {
                            await uploadVM.pickFilesFromDevice(
                              bucketName: "attachments",
                              singleFileMode: false,
                            );
                            final state = uploadVM.state;
                            if (state is UploadAttachmentsViewModelStatesSuccess) {
                              final attachments = state.attachments
                                  .map((e) => AttachmentModel(
                                id: e.id,
                                name: e.name,
                                type: e.type,
                                url: e.url,
                                storagePath: e.storagePath,
                                size: e.size,
                              ))
                                  .toList();
                              if (attachments.isNotEmpty) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _handleAttachmentUpload(attachments);
                                });
                              }
                            }
                          },
                        );
                      },
                    ),

                    const SizedBox(width: 8),

                    // حقل النص
                    Expanded(
                      child: TextField(
                        controller: viewModel.textController,
                        onChanged: (value) => viewModel.updateTyping(value.trim().isNotEmpty),
                        decoration: const InputDecoration(
                          hintText: 'اكتب رسالة...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // زر الإرسال أو التسجيل
                    if (viewModel.pendingAttachments.isNotEmpty || viewModel.isTyping)
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: viewModel.pendingAttachments.isNotEmpty
                            ? _sendPendingAttachments
                            : _sendTextMessage,
                      )
                    else
                      IconButton(
                        icon: Icon(
                          viewModel.isRecording ? Icons.stop : Icons.mic,
                          color: viewModel.isRecording ? Colors.red : Colors.grey,
                        ),
                        onPressed: _startOrStopRecording,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}