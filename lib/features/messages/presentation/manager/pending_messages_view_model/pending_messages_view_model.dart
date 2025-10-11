// manager/pending_messages_view_model/pending_messages_view_model.dart
import 'package:flutter/foundation.dart';

import '../../../data/models/pending_message_model/pending_message_model.dart';

class PendingMessagesViewModel extends ChangeNotifier {
  final List<PendingMessage> _pendingMessages = [];

  List<PendingMessage> get pendingMessages => List.unmodifiable(_pendingMessages);

  void addPendingMessage(PendingMessage message) {
    _pendingMessages.add(message);
    notifyListeners();
    print('✅ تم إضافة رسالة مؤقتة: ${message.id} - إجمالي الرسائل: ${_pendingMessages.length}');
  }

  void updateUploadProgress(String messageId, double progress) {
    final index = _pendingMessages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _pendingMessages[index] = _pendingMessages[index].copyWith(
        uploadProgress: progress,
      );
      notifyListeners();
      print('📈 تحديث تقدم الرسالة: $messageId - ${(progress * 100).toInt()}%');
    } else {
      print('❌ لم يتم العثور على الرسالة: $messageId');
    }
  }

  void updateMessageWithFileUrl(String messageId, String fileUrl) {
    final index = _pendingMessages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _pendingMessages[index] = _pendingMessages[index].copyWith(
        fileUrl: fileUrl,
        uploadProgress: 1.0,
      );
      notifyListeners();
      print('🔗 تحديث رابط الملف: $messageId');
    }
  }
  void removePendingMessage(String messageId) {
    final oldLength = _pendingMessages.length;
    _pendingMessages.removeWhere((msg) => msg.id == messageId);
    if (_pendingMessages.length < oldLength) {
      notifyListeners();
      print('🗑️ تم إزالة الرسالة: $messageId - الرسائل المتبقية: ${_pendingMessages.length}');
    }
  }


  void clearAll() {
    _pendingMessages.clear();
    notifyListeners();
  }
}