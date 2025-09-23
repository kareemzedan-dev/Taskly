import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/messages/data/models/message_model.dart';
import 'package:taskly/features/shared/data/models/order_dm/order_dm.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../features/shared/domain/entities/order_entity/order_entity.dart';
import '../../../../welcome/presentation/cubit/welcome_states.dart';
import '../../../domain/entities/message_entity.dart';
import '../../data_sources/remote/messages_remote_data_source.dart';

@Injectable(as: MessagesRemoteDataSource)
class MessagesRemoteDataSourceImpl implements MessagesRemoteDataSource {
  final SupabaseClient supabase;
  final SupabaseService supabaseService;

  MessagesRemoteDataSourceImpl(this.supabase,this.supabaseService);

  @override
  Future<Either<Failures, List<OrderEntity>>> getAcceptedOrderMessages(
      String userId, UserRole role) async {
    try {
      final column = role == UserRole.freelancer ? 'freelancer_id' : 'client_id';

      final response = await supabase
          .from('orders')
          .select()
          .eq(column, userId)
          .inFilter('status', [
        'Accepted',
        'Rejected',
        'Paid',
        'AwaitingPaymentConfirmation',
        'In Progress',
        'Completed'
      ]);

      final data = (response as List)
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
  Future<Either<Failures, MessageEntity>> sendMessage(
      String orderId, MessageEntity message) async {
    try {
      print("Preparing to send message to orderId=$orderId");

      final String generatedId = const Uuid().v4();

      final paymentResponse = await supabase
          .from('payments')
          .select('id')
          .eq('order_id', orderId)
          .maybeSingle();

      final paymentId =
      paymentResponse != null ? paymentResponse['id'] as String : null;
      print("Fetched paymentId: $paymentId");

      final response = await supabase.from('messages').insert({
        'id': generatedId,
        'order_id': orderId,
        'sender_id': message.senderId,
        'receiver_id': message.receiverId,
        'payment_id': paymentId,
        'message_type': message.messageType,
        'content': message.content,
        'attachment': message.attachment != null
            ? jsonEncode(message.attachment!.map((e) => e.toJson()).toList())
            : null,
        'status': message.status,
        'created_at': message.createdAt.toIso8601String(),
        'updated_at': message.updatedAt.toIso8601String(),
      }).select().single();

      print("Message inserted: $response");

      return Right(MessageModel.fromJson(response));
    } on PostgrestException catch (e) {
      print("PostgrestException: ${e.message}");
      return Left(ServerFailure(e.message));
    } catch (e) {
      print("Unknown error: $e");
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
  @override
  Future<RealtimeChannel> subscribeToMessages(
      String orderId,
      void Function(MessageEntity message, String action) onChange,
      ) async {
    final channel = supabase.channel('messages:$orderId');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        final record = payload.newRecord;
        if (record == null) return;
        final message = MessageModel.fromJson(
          Map<String, dynamic>.from(record),
        );
        onChange(message, 'INSERT');
      },
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        final record = payload.newRecord; // بعد التعديل
        if (record == null) return;
        final message = MessageModel.fromJson(
          Map<String, dynamic>.from(record),
        );
        onChange(message, 'UPDATE');
      },
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        final record = payload.oldRecord; // قبل الحذف
        if (record == null) return;
        final message = MessageModel.fromJson(
          Map<String, dynamic>.from(record),
        );
        onChange(message, 'DELETE');
      },
    );

    // هنا بقى بنعمل subscribe بعد ما ضفنا كل الـ listeners
    await channel.subscribe();

    return channel;
  }


}