import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../../core/services/supabase_service.dart';
import '../../../data_sources/remote/subscribe_to_admin_messages_remote_data_source/subscribe_to_admin_messages_remote_data_source.dart';
import '../../../models/message_model.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../../attachments/data/models/attachments_dm/attachments_dm.dart';

@Injectable(as: SubscribeToAdminMessagesRemoteDataSource)
class SubscribeToAdminMessagesRemoteDataSourceImpl
    implements SubscribeToAdminMessagesRemoteDataSource {
  final SupabaseService supabaseService;

  SubscribeToAdminMessagesRemoteDataSourceImpl(this.supabaseService);

  @override
  Future<RealtimeChannel> subscribeToAdminMessages(
      String currentUserId,
      void Function(MessageEntity message, String action) onChange,
      ) async {
    print("🔹 Starting admin messages subscription for user: $currentUserId");

    try {
      final adminsResponse = await supabaseService.supabaseClient
          .from('admins')
          .select('id');
      print("🟢 Admins response: $adminsResponse");

      final adminIds = (adminsResponse as List)
          .map((e) => e['id']?.toString())
          .where((id) => id != null && id.isNotEmpty)
          .cast<String>()
          .toList();
      print("🟢 Parsed admin IDs: $adminIds");

      if (adminIds.isEmpty) {
        print("⚠️ No admins available to subscribe to messages.");
        throw Exception("No admins available.");
      }

      final channel = supabaseService.supabaseClient.channel('admin_messages_channel');
      print("🔹 Channel created: ${channel.presence}");

      // Listen for inserts
      channel.onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'messages',
        callback: (payload) {
          print("🟢 Insert event received");
          _handlePayload(payload, currentUserId, adminIds, onChange, 'INSERT');
        },
      );

      // Listen for updates
      channel.onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'messages',
        callback: (payload) {
          print("🔵 Update event received");
          _handlePayload(payload, currentUserId, adminIds, onChange, 'UPDATE');
        },
      );

      // Listen for deletes
      channel.onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: 'messages',
        callback: (payload) {
          print("🔴 Delete event received");
          _handlePayload(payload, currentUserId, adminIds, onChange, 'DELETE');
        },
      );

      channel.subscribe();
      print("✅ Subscription completed for admin messages");

      return channel;
    } catch (e) {
      print('❌ Error subscribing to admin messages: $e');
      rethrow;
    }
  }

  void _handlePayload(
      PostgresChangePayload payload,
      String currentUserId,
      List<String> adminIds,
      void Function(MessageEntity message, String action) onChange,
      String action,
      ) {
    try {
      print("➡️ Handling payload: $payload");

      final record = payload.newRecord ?? payload.oldRecord;

      final senderId = record['sender_id']?.toString();
      final receiverId = record['receiver_id']?.toString();
      if (senderId == null || receiverId == null) {
        print("⚠️ senderId or receiverId is null");
        return;
      }

      final isAdminMessage = (senderId == currentUserId && adminIds.contains(receiverId)) ||
          (receiverId == currentUserId && adminIds.contains(senderId));

      if (!isAdminMessage) {
        print("⚠️ Not an admin message, skipping");
        return;
      }

      final message = MessageModel.fromJson(Map<String, dynamic>.from(record));
      print("✅ Message parsed successfully: ${message.content}");
      onChange(message, action);

    } catch (e) {
      print('❌ Error processing payload: $e');
      print('Payload content: ${payload.newRecord ?? payload.oldRecord}');
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
      } else if (attachmentData is Map<String, dynamic>) {
        return [AttachmentModel.fromJson(attachmentData)];
      }
    } catch (e) {
      print('❌ Error parsing attachments: $e');
      print('Attachment data: $attachmentData');
    }
    return null;
  }

  DateTime? _parseDateTime(dynamic dateTimeData) {
    if (dateTimeData == null) return null;
    try {
      if (dateTimeData is DateTime) return dateTimeData;
      if (dateTimeData is String) {
        final parsed = DateTime.tryParse(dateTimeData);
        if (parsed != null) return parsed;
        final timestamp = int.tryParse(dateTimeData);
        if (timestamp != null) return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      if (dateTimeData is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateTimeData);
      }
    } catch (e) {
      print('❌ Error parsing datetime: $e');
      print('DateTime data: $dateTimeData');
    }
    return null;
  }
}
