import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/features/messages/domain/repositories/messages_repos/subscribe_to_messages_repo/subscribe_to_messages_repo.dart';

import '../../entities/message_entity.dart';
 
@injectable
class SubscribeToMessagesUseCase  {
  final SubscribeToMessagesRepo repos;
  SubscribeToMessagesUseCase(this.repos);
  Future<RealtimeChannel> call(String orderId, void Function(MessageEntity message, String action) onChange) {
    return repos.subscribeToMessages(orderId, onChange);
  }
}