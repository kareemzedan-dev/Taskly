import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/messages/data/data_sources/remote/subscribe_to_messages_remote_data_source/subscribe_to_messages_remote_data_source.dart';
import 'package:taskly/features/messages/data/models/message_model.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';

@Injectable(as: SubscribeToMessagesRemoteDataSource)
class SubscribeToMessagesRemoteDataSourceImpl
    implements SubscribeToMessagesRemoteDataSource {
  final SupabaseService supabaseService;

  SubscribeToMessagesRemoteDataSourceImpl({required this.supabaseService});

  @override
  Stream<(MessageEntity, String)> subscribeToMessages(String orderId) {
    final client = supabaseService.supabaseClient;
    final controller = StreamController<(MessageEntity, String)>();

    final channel = client.channel(
      'messages:order_$orderId',
      opts: const RealtimeChannelConfig(),
    );

    void handleChange(PostgresChangeEvent eventType, Map<String, dynamic>? record) {
      if (record == null) return;
      final message = MessageModel.fromJson(record);
      controller.add((message, eventType.name.toUpperCase()));
    }

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'order_id',
        value: orderId,
      ),
      callback: (payload) =>
          handleChange(PostgresChangeEvent.insert, payload.newRecord),
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'order_id',
        value: orderId,
      ),
      callback: (payload) =>
          handleChange(PostgresChangeEvent.update, payload.newRecord),
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'order_id',
        value: orderId,
      ),
      callback: (payload) =>
          handleChange(PostgresChangeEvent.delete, payload.oldRecord),
    );

    // ✅ subscribe
    channel.subscribe();

    // 🧹 close stream properly
    controller.onCancel = () {
      channel.unsubscribe();
    };

    return controller.stream;
  }
}
