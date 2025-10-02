import 'package:injectable/injectable.dart';
import 'package:realtime_client/src/realtime_channel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../core/services/supabase_service.dart';
import '../../../data_sources/remote/subscribe_to_admin_messages_remote_data_source/subscribe_to_admin_messages_remote_data_source.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../../attachments/data/models/attachments_dm/attachments_dm.dart';
@Injectable(as: SubscribeToAdminMessagesRemoteDataSource)
class SubscribeToAdminMessagesRemoteDataSourceImpl
    implements SubscribeToAdminMessagesRemoteDataSource {
  final SupabaseService supabaseService;

  SubscribeToAdminMessagesRemoteDataSourceImpl(this.supabaseService);

  @override
  Future<RealtimeChannel> subscribeToAdminMessages(String currentUserId) async {
    try {
      // جلب كل الادمنز
      final adminsResponse = await supabaseService.supabaseClient
          .from('admins')
          .select('id');

      final adminIds = (adminsResponse as List)
          .map((e) => e['id'].toString())
          .toList();

      // لو مفيش admins نستخدم dummy id عشان ما نرجعش null
      final safeAdminIds = adminIds.isEmpty ? ['dummy'] : adminIds;

      final channel = supabaseService.supabaseClient
          .channel('admin_messages_$currentUserId')
          .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'messages',
        callback: (payload) {
          try {
            final record = payload.newRecord ?? payload.oldRecord;
            if (record == null) return;

            final senderId = record['sender_id']?.toString();
            final receiverId = record['receiver_id']?.toString();

            if (senderId == null || receiverId == null) return;

            // التحقق من أن الرسالة بين المستخدم والأدمن
            final isAdminMessage =
                (senderId == currentUserId && safeAdminIds.contains(receiverId)) ||
                    (receiverId == currentUserId && safeAdminIds.contains(senderId));

            if (!isAdminMessage) return;

            final message = MessageEntity(
              id: record['id']?.toString() ?? '',
              orderId: record['order_id']?.toString(),
              paymentId: record['payment_id']?.toString(),
              senderId: senderId,
              receiverId: receiverId,
              messageType: record['message_type']?.toString() ?? 'text',
              content: record['content']?.toString() ?? '',
              attachment: _parseAttachments(record['attachment']),
              status: record['status']?.toString() ?? 'sent',
              deliveredAt: _parseDateTime(record['delivered_at']),
              seenAt: _parseDateTime(record['seen_at']),
              createdAt: _parseDateTime(record['created_at']) ?? DateTime.now(),
              updatedAt: _parseDateTime(record['updated_at']) ?? DateTime.now(),
            );

            print("New admin message: ${message.content}");

            // هنا يمكنك إرسال الـ message إلى الـ stream أو الـ bloc
            // مثلاً باستخدام StreamController

          } catch (e) {
            print('Error processing message: $e');
          }
        },
      )
          .subscribe();

      return channel;
    } catch (e) {
      print('Error subscribing to admin messages: $e');
      rethrow;
    }
  }

  List<AttachmentModel>? _parseAttachments(dynamic attachmentData) {
    if (attachmentData == null) return null;

    try {
      if (attachmentData is List) {
        return attachmentData
            .whereType<Map<String, dynamic>>()
            .map((a) => AttachmentModel.fromJson(a))
            .toList();
      }
    } catch (e) {
      print('Error parsing attachments: $e');
    }

    return null;
  }

  DateTime? _parseDateTime(dynamic dateTimeData) {
    if (dateTimeData == null) return null;

    try {
      if (dateTimeData is DateTime) return dateTimeData;
      if (dateTimeData is String) return DateTime.tryParse(dateTimeData);
    } catch (e) {
      print('Error parsing datetime: $e');
    }

    return null;
  }
}
