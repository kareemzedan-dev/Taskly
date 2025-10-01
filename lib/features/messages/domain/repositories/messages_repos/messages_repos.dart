import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../welcome/presentation/cubit/welcome_states.dart';

/// Repository interface for messages feature
abstract class MessagesRepos {
  /// Get messages of accepted orders (for client or freelancer)
  Future<Either<Failures, List<OrderEntity>>> getAcceptedOrderMessages(String userId,{UserRole? role});

  /// Get messages for a specific order
  Future<Either<Failures, List<MessageEntity>>> getOrderMessages(String orderId);

  /// Send a message in an order
  Future<Either<Failures, MessageEntity>> sendMessage(String orderId, MessageEntity message);

  /// Mark messages as read
  Future<Either<Failures, void>> markMessagesAsRead(String orderId);

  /// Delete a message
  Future<Either<Failures, void>> deleteMessage(String messageId);

  /// Subscribe to messages for a specific order
  Future<RealtimeChannel> subscribeToMessages(String orderId, void Function(MessageEntity message, String action) onChange);
}
