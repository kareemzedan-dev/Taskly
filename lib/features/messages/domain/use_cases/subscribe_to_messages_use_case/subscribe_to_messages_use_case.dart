// import 'package:injectable/injectable.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../entities/message_entity.dart';
// import '../../repositories/messages_repos/messages_repos.dart';
// @injectable
// class SubscribeToMessagesUseCase  {
//   final MessagesRepos repos;
//   SubscribeToMessagesUseCase(this.repos);
//   Future<RealtimeChannel> call(String orderId, void Function(MessageEntity message, String action) onChange) {
//     return repos.subscribeToMessages(orderId, onChange);
//   }
// }