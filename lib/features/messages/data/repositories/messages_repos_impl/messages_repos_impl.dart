import '../../../domain/repositories/messages_repos/messages_repos.dart';
import '../../data_sources/remote/messages_remote_data_source.dart';
import 'package:either_dart/either.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../../../features/shared/domain/entities/order_entity/order_entity.dart';

class MessagesReposImpl implements MessagesRepos {
  final MessagesRemoteDataSource remoteDataSource;
  MessagesReposImpl(this.remoteDataSource);

  @override
  Future<Either<Failures, List<OrderEntity>>> getAcceptedOrderMessages(String userId) {
    return remoteDataSource.getAcceptedOrderMessages(userId);
  }

  Future<Either<Failures, List<MessageEntity>>> getOrderMessages(String orderId) {
    return remoteDataSource.getOrderMessages(orderId);
  }

  Future<Either<Failures, MessageEntity>> sendMessage(String orderId, MessageEntity message) {
    return remoteDataSource.sendMessage(orderId, message);
  }

  Future<Either<Failures, void>> markMessagesAsRead(String orderId) {
    return remoteDataSource.markMessagesAsRead(orderId);
  }

  Future<Either<Failures, void>> deleteMessage(String messageId) {
    return remoteDataSource.deleteMessage(messageId);
  }
}
