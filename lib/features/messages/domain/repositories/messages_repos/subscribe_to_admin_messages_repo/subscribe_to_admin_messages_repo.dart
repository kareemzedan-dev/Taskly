import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SubscribeToAdminMessagesRepo {
  Future<RealtimeChannel> subscribeToAdminMessages(String currentUserId);
}