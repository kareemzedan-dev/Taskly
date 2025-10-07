

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/messages/data/data_sources/remote/subscribe_to_messages_remote_data_source/subscribe_to_messages_remote_data_source.dart';
import 'package:taskly/features/messages/data/models/message_model.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';
@Injectable(as:  SubscribeToMessagesRemoteDataSource)
class SubscribeToMessagesRemoteDataSourceImpl implements SubscribeToMessagesRemoteDataSource {
  final SupabaseService supabaseService;

  SubscribeToMessagesRemoteDataSourceImpl({required this.supabaseService});

  @override
  Future<RealtimeChannel> subscribeToMessages(
      String orderId,
      void Function(MessageEntity message, String action) onChange,
      ) async {
    final channel = supabase.channel(
      'messages:order_$orderId',
      opts: const RealtimeChannelConfig(),
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'order_id',
        value: orderId,
      ),
      callback: (payload) {
        final record = payload.newRecord;
        final message = MessageModel.fromJson(
          Map<String, dynamic>.from(record),
        );
        onChange(message, 'INSERT');
      },
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
      callback: (payload) {
        final record = payload.newRecord;
        final message = MessageModel.fromJson(
          Map<String, dynamic>.from(record),
        );
        onChange(message, 'UPDATE');
      },
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
      callback: (payload) {
        final record = payload.oldRecord;
        final message = MessageModel.fromJson(
          Map<String, dynamic>.from(record),
        );
        onChange(message, 'DELETE');
      },
    );

    channel.subscribe();
    return channel;
  }
}
