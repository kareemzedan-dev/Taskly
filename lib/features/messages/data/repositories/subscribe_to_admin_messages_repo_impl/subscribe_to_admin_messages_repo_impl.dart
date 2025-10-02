import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/repositories/messages_repos/subscribe_to_admin_messages_repo/subscribe_to_admin_messages_repo.dart';
import '../../data_sources/remote/subscribe_to_admin_messages_remote_data_source/subscribe_to_admin_messages_remote_data_source.dart';
@Injectable(as:  SubscribeToAdminMessagesRepo)
  class SubscribeToAdminMessagesRepoImpl implements SubscribeToAdminMessagesRepo {

    final SubscribeToAdminMessagesRemoteDataSource remoteDataSource;
    SubscribeToAdminMessagesRepoImpl(this.remoteDataSource);
    @override
    Future<RealtimeChannel> subscribeToAdminMessages(String currentUserId) {
      return remoteDataSource.subscribeToAdminMessages(currentUserId);
    }
}