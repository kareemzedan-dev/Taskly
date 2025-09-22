import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/features/messages/data/models/message_model.dart';
import 'package:taskly/features/shared/data/models/order_dm/order_dm.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../features/shared/domain/entities/order_entity/order_entity.dart';
import '../../../domain/entities/message_entity.dart';
import '../../data_sources/remote/messages_remote_data_source.dart';

@Injectable(as: MessagesRemoteDataSource)
class MessagesRemoteDataSourceImpl implements MessagesRemoteDataSource {
  final SupabaseClient supabase;

  MessagesRemoteDataSourceImpl(this.supabase);

  @override
  Future<Either<Failures, List<OrderEntity>>> getAcceptedOrderMessages(String userId) async {
    try {
      final response = await supabase
          .from('orders')
          .select()
          .eq('client_id', userId)
          .inFilter('status', ['pending', 'accepted', 'rejected', 'Awaiting Approval']);

      final data = response
          .map((e) => OrderDm.fromJson(e))
          .toList();

      return Right(data);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<MessageEntity>>> getOrderMessages(String orderId) async {
    try {
      final response = await supabase
          .from('messages')
          .select()
          .eq('order_id', orderId)
          .order('created_at', ascending: true);

      final data = response
          .map((e) => MessageModel.fromJson(e))
          .toList();

      return Right(data);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, MessageEntity>> sendMessage(String orderId, MessageEntity message) async {
    try {
      final response = await supabase
          .from('messages')
          .insert({
        'id': message.id,
        'order_id': orderId,
        'sender_id': message.senderId,
        'text': message.content,
        'attachments': message.attachment != null
            ? jsonEncode(message.attachment!.map((e) => e.toJson()).toList())
            : null,
        'created_at': message.createdAt.toIso8601String(),
      })
          .select()
          .single();

      return Right(MessageModel.fromJson(response));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> markMessagesAsRead(String orderId) async {
    try {
      await supabase
          .from('messages')
          .update({'is_read': true})
          .eq('order_id', orderId);

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> deleteMessage(String messageId) async {
    try {
      await supabase
          .from('messages')
          .delete()
          .eq('id', messageId);

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}