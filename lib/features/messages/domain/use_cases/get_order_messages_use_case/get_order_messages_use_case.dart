import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../features/messages/domain/entities/message_entity.dart';
import '../../repositories/messages_repos/messages_repos.dart';

@lazySingleton
class GetOrderMessagesUseCase {
  final MessagesRepos repository;

  GetOrderMessagesUseCase(this.repository);

  Future<Either<Failures, List<MessageEntity>>> call(String orderId) {
    return repository.getOrderMessages(orderId);
  }
  Future<RealtimeChannel> callSubscribe(String orderId, void Function(MessageEntity message, String action) onChange) {
    return repository.subscribeToMessages(orderId, onChange);
  }
}
