import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../features/shared/domain/entities/order_entity/order_entity.dart';
import '../../../../welcome/presentation/cubit/welcome_states.dart';
import '../../../domain/entities/message_entity.dart';

abstract class MessagesRemoteDataSource {
  /// Get accepted orders for a specific user
  Future<Either<Failures, List<OrderEntity>>> getAcceptedOrderMessages(String userId, UserRole role);

  /// Get all messages for a specific order
  Future<Either<Failures, List<MessageEntity>>> getOrderMessages(String orderId);

  /// Send a message for a specific order
  Future<Either<Failures, MessageEntity>> sendMessage(String orderId, MessageEntity message);

  /// Mark messages as read for a specific order
  Future<Either<Failures, void>> markMessagesAsRead(String orderId);

  /// Delete a specific message
  Future<Either<Failures, void>> deleteMessage(String messageId);
  /// Subscribe to messages for a specific order
 Future<RealtimeChannel> subscribeToMessages(String orderId, void Function(MessageEntity message, String action) onChange);
}
