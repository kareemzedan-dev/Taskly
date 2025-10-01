import 'package:injectable/injectable.dart';
import 'package:realtime_client/src/realtime_channel.dart';

import '../../../../welcome/presentation/cubit/welcome_states.dart';
import '../../../domain/repositories/messages_repos/messages_repos.dart';
import '../../data_sources/remote/messages_remote_data_source.dart';
import 'package:either_dart/either.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../../../features/shared/domain/entities/order_entity/order_entity.dart';
@Injectable(as: MessagesRepos)
class MessagesReposImpl implements MessagesRepos {
  final MessagesRemoteDataSource remoteDataSource;
  MessagesReposImpl(this.remoteDataSource);

  @override
  Future<Either<Failures, List<OrderEntity>>> getAcceptedOrderMessages(String userId, {UserRole? role}) {
    return remoteDataSource.getAcceptedOrderMessages(userId,   role:   role  );
  }
  @override
  Future<Either<Failures, List<MessageEntity>>> getOrderMessages(String orderId) {
    return remoteDataSource.getOrderMessages(orderId);
  }
  @override
  Future<Either<Failures, MessageEntity>> sendMessage(String orderId, MessageEntity message) {
    return remoteDataSource.sendMessage(orderId, message);
  }
  @override
  Future<Either<Failures, void>> markMessagesAsRead(String orderId) {
    return remoteDataSource.markMessagesAsRead(orderId);
  }
  @override
  Future<Either<Failures, void>> deleteMessage(String messageId) {
    return remoteDataSource.deleteMessage(messageId);
  }

  @override
  Future<RealtimeChannel> subscribeToMessages(String orderId, void Function(MessageEntity message, String action) onChange) {
     return remoteDataSource.subscribeToMessages(orderId, onChange);
  }


}
