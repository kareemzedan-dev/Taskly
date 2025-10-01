

import 'dart:convert';

import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/messages/data/data_sources/remote/send_messages_remote_data_source/send_messages_remote_data_source.dart';
import 'package:taskly/features/messages/data/models/message_model.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';
import 'package:uuid/uuid.dart';
@Injectable(as:  SendMessagesRemoteDataSource)
class SendMessagesRemoteDataSourceImpl extends SendMessagesRemoteDataSource {
  final SupabaseService supabaseService;

  SendMessagesRemoteDataSourceImpl(this.supabaseService);
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
}