import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../repositories/messages_repos/subscribe_to_admin_messages_repo/subscribe_to_admin_messages_repo.dart';
@injectable
  class SubscribeToAdminMessagesUseCase {
    SubscribeToAdminMessagesUseCase(this.repository);
    final SubscribeToAdminMessagesRepo repository;
  Future<RealtimeChannel> subscribeToAdminMessages(String currentUserId){
    return repository.subscribeToAdminMessages(currentUserId);
  }
}