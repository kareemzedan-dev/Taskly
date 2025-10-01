 import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';

abstract class SubscribeToMessagesRemoteDataSource {
   Future<RealtimeChannel> subscribeToMessages(String orderId, void Function(MessageEntity message, String action) onChange);
 }