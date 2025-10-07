import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/di/di.dart';
import '../../../../core/services/message_validation_service.dart';
import '../../../attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model_states.dart';
import '../../domain/entities/message_entity.dart';
import '../manager/send_message_view_model/send_message_view_model.dart';
import '../manager/send_message_view_model/send_message_view_model_states.dart';

class ChatInputField extends StatefulWidget {
  final String? orderId;
  final String currentUserId;
  final String receiverId;

  const ChatInputField({
    super.key,
    this.orderId,
    required this.currentUserId,
    required this.receiverId,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

final MessageValidationService _validationService = MessageValidationService();

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isSending = false;
  String? _recordingPath;

  Future<bool> _checkPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecording() async {
    try {
      final hasPermission = await _checkPermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission required')),
        );
        return;
      }

      final dir = await getTemporaryDirectory();
      _recordingPath = '${dir.path}/${const Uuid().v4()}.m4a';

      await _audioRecorder.start(
        const RecordConfig(),
        path: _recordingPath!,
      );

      setState(() => _isRecording = true);
    } catch (e) {
      print('Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start recording: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      setState(() => _isRecording = false);

      if (_recordingPath != null && File(_recordingPath!).existsSync()) {
        await _sendVoiceMessage(_recordingPath!);
      }
    } catch (e) {
      print('Error stopping recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop recording: $e')),
      );
    } finally {
      _recordingPath = null;
    }
  }

  Future<void> _sendVoiceMessage(String filePath) async {
    if (!mounted) return;

    setState(() => _isSending = true);

    try {
      final uploadVM = context.read<UploadAttachmentsViewModel>();

      uploadVM.files = [File(filePath)];
      await uploadVM.uploadAttachments(bucketName: "attachments");

      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return uploadVM.state is! UploadAttachmentsViewModelStatesSuccess &&
            uploadVM.state is! UploadAttachmentsViewModelStatesError;
      });

      if (uploadVM.state is UploadAttachmentsViewModelStatesSuccess &&
          mounted) {
        final attachments =
            (uploadVM.state as UploadAttachmentsViewModelStatesSuccess)
                .attachments
                .map((e) => AttachmentModel.fromEntity(e))
                .toList();

        context.read<SendMessageViewModel>().sendMessage(
              widget.orderId!,
              MessageEntity(
                id: const Uuid().v4(),
                orderId: widget.orderId,
                senderId: widget.currentUserId,
                receiverId: widget.receiverId,
                paymentId: null,
                messageType: "voice",
                content: null,
                attachment: attachments,
                status: "sent",
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
        print("✅ Voice message sent successfully");
      } else {
        print("❌ Upload state is not success or widget unmounted.");
      }
    } catch (e) {
      print('Error sending voice message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send voice message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  void _sendTextMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Validate message
    final validationMessage = _validationService.validate(text);
    if (validationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationMessage),
          backgroundColor: Colors.red,
        ),
      );
      return; // stop sending
    }

    // Message is valid, send it
    context.read<SendMessageViewModel>().sendMessage(
          widget.orderId!,
          MessageEntity(
            id: const Uuid().v4(),
            orderId: widget.orderId,
            senderId: widget.currentUserId,
            receiverId: widget.receiverId,
            paymentId: null,
            messageType: "text",
            content: text,
            attachment: null,
            status: "sent",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    _controller.clear();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
              _buildAttachmentButton(),
              SizedBox(width: 8.w),
              _buildVoiceRecordButton(),
              SizedBox(width: 8.w),
              Expanded(child: _buildMessageInput()),
              SizedBox(width: 8.w),
              _buildSendState(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentButton() {
    return BlocBuilder<UploadAttachmentsViewModel,
        UploadAttachmentsViewModelStates>(
      builder: (context, uploadState) {
        final isLoading =
            uploadState is UploadAttachmentsViewModelStatesLoading;

        return Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    FontAwesomeIcons.paperclip,
                    size: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    context
                        .read<UploadAttachmentsViewModel>()
                        .pickFilesFromDevice(
                          bucketName: "attachments",
                          singleFileMode: true,
                        );
                  },
                ),
        );
      },
    );
  }

  Widget _buildVoiceRecordButton() {
    return Container(
      width: 44.w,
      height: 44.h,
      decoration: BoxDecoration(
        color:
            _isRecording ? Colors.red.withOpacity(0.1) : Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
          size: 20.sp,
          color: _isRecording ? Colors.red : Colors.grey.shade700,
        ),
        onPressed: _isSending
            ? null
            : _isRecording
                ? _stopRecording
                : _startRecording,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300, width: 1.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14.sp,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: 1,
                onSubmitted: (_) => _sendTextMessage(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              icon: Icon(
                CupertinoIcons.paperplane_fill,
                size: 20.sp,
                color: Colors.blue,
              ),
              onPressed: _sendTextMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendState() {
    return BlocBuilder<SendMessageViewModel, SendMessageViewModelStates>(
      builder: (context, state) {
        final isLoading = state is SendMessageViewModelStatesLoading;

        if (isLoading || _isSending) {
          return SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              color: Colors.blue,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
