import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:taskly/core/services/message_validation_service.dart';
import 'package:taskly/core/services/voice_recording_service.dart';
import 'package:taskly/features/attachments/data/models/attachments_dm/attachments_dm.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import '../../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model_states.dart';
import '../send_message_view_model/send_message_view_model.dart';
@singleton


class ChatInputViewModel extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final AudioRecorder audioRecorder = AudioRecorder();

  bool _isTyping = false;
  bool _isSending = false;
  bool _isRecording = false;

  bool get isTyping => _isTyping;
  bool get isSending => _isSending;
  bool get isRecording => _isRecording;

  void updateTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }

  void updateSending(bool sending) {
    _isSending = sending;
    notifyListeners();
  }

  void updateRecording(bool recording) {
    _isRecording = recording;
    notifyListeners();
  }

  // Text Message Logic
  void sendTextMessage({
    required BuildContext context,
    required String? orderId,
    required String currentUserId,
    required String receiverId,
    required String senderType,
    required String receiverType,
    VoidCallback? onMessageSent,
  }) {
    final text = textController.text.trim();
    if (text.isEmpty || _isSending) return;

    _isSending = true;
    notifyListeners();

    final message = MessageEntity(
      id: const Uuid().v4(),
      orderId: orderId,
      senderId: currentUserId,
      receiverId: receiverId,
      paymentId: null,
      messageType: "text",
      content: text,
      attachment: null,
      status: "sent",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      senderType: senderType,
      receiverType: receiverType,

    );

    context.read<SendMessageViewModel>().sendMessage(orderId!, message);
    textController.clear();
    _isTyping = false;
    _isSending = false;
    notifyListeners();

    onMessageSent?.call();
  }

  // Voice Recording Logic
  Future<void> startOrStopRecording({
    required BuildContext context,
    required String? orderId,
    required String currentUserId,
    required String receiverId,
    required String senderType,
    required String receiverType,
    VoidCallback? onMessageSent,
  }) async {
    if (_isRecording) {
      // Stop recording
      final path = await audioRecorder.stop();
      if (path != null) {
        final file = File(path);
        _isRecording = false;
        notifyListeners();

        // Upload the recorded file
        await _uploadVoiceMessage(
          context: context,
          file: file,
          orderId: orderId,
          currentUserId: currentUserId,
          receiverId: receiverId,
          senderType: senderType,
          receiverType: receiverType,
          onMessageSent: onMessageSent,
        );
      }
    } else {
      final permission = await Permission.microphone.request();
      if (!permission.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission denied")),
        );
        return;
      }

      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a";

      await audioRecorder.start(
        path: filePath,
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
      );

      _isRecording = true;
      notifyListeners();
    }
  }

  Future<void> _uploadVoiceMessage({
    required BuildContext context,
    required File file,
    required String? orderId,
    required String currentUserId,
    required String receiverId,
    required String senderType,
    required String receiverType,
    VoidCallback? onMessageSent,
  }) async {
    _isSending = true;
    notifyListeners();

    try {
      final uploadVM = context.read<UploadAttachmentsViewModel>();
      uploadVM.files.add(file);
      uploadVM.generateFileKey(file);

      await uploadVM.uploadAttachments(bucketName: "attachments");

      // Wait for upload completion
      await _waitForUploadCompletion(uploadVM);

      if (uploadVM.state is UploadAttachmentsViewModelStatesSuccess) {
        final attachments = (uploadVM.state as UploadAttachmentsViewModelStatesSuccess)
            .attachments
            .map((e) => AttachmentModel.fromEntity(e))
            .toList();

        final message = MessageEntity(
          id: const Uuid().v4(),
          orderId: orderId,
          senderId: currentUserId,
          receiverId: receiverId,
          paymentId: null,
          messageType: "audio",
          content: null,
          attachment: attachments,
          status: "sent",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          senderType: senderType,
          receiverType: receiverType,
        );

        context.read<SendMessageViewModel>().sendMessage(orderId!, message);
        onMessageSent?.call();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> _waitForUploadCompletion(UploadAttachmentsViewModel uploadVM) async {
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      return uploadVM.state is! UploadAttachmentsViewModelStatesSuccess &&
          uploadVM.state is! UploadAttachmentsViewModelStatesError;
    });
  }

  // Attachment Logic
  void handleAttachmentUpload({
    required List<AttachmentModel> attachments,
    required BuildContext context,
    required String? orderId,
    required String currentUserId,
    required String receiverId,
    required String senderType,
    required String receiverType,
    VoidCallback? onMessageSent,
  }) {
    if (attachments.isEmpty || _isSending) return;

    _isSending = true;
    notifyListeners();

    final first = attachments.first;
    final isImage = first.type.startsWith("image/");
    final isAudio = first.type.startsWith("audio/");
    final messageType = isImage ? "image" : isAudio ? "audio" : "file";

    final message = MessageEntity(
      id: const Uuid().v4(),
      orderId: orderId,
      senderId: currentUserId,
      receiverId: receiverId,
      paymentId: null,
      messageType: messageType,
      content: null,
      attachment: attachments,
      status: "sent",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      senderType: senderType,
      receiverType: receiverType,
    );

    context.read<SendMessageViewModel>().sendMessage(orderId!, message);
    _isSending = false;
    notifyListeners();
    onMessageSent?.call();
  }

  @override
  void dispose() {
    textController.dispose();
    audioRecorder.dispose();
    super.dispose();
  }
}