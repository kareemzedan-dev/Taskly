import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SubscribeToAdminMessagesRemoteDataSource {
  Future<RealtimeChannel> subscribeToAdminMessages(String currentUserId);
}