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

@Injectable(as: SendMessagesRemoteDataSource)
class SendMessagesRemoteDataSourceImpl extends SendMessagesRemoteDataSource {
  final SupabaseService supabaseService;

  SendMessagesRemoteDataSourceImpl(this.supabaseService);

  @override
  Future<Either<Failures, MessageEntity>> sendMessage(
      String orderId, MessageEntity message) async {


    final phoneRegex = RegExp(r'(\+201[0-9]{9}|01[0-9]{9}|[0-9]{8,})');
    final urlRegex = RegExp(r'(https?:\/\/|www\.|facebook\.com|wa\.me|whatsapp\.com)');
    final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');

    if (phoneRegex.hasMatch( message.content!)) {
      return Left(ServerFailure("🚫 يمنع إرسال أرقام التليفون داخل الرسائل"));
    }

    if (urlRegex.hasMatch(message.content!)) {
      return Left(ServerFailure("🚫 يمنع إرسال الروابط داخل الرسائل"));
    }

    if (emailRegex.hasMatch(message.content!)) {
      return Left(ServerFailure("🚫 يمنع إرسال الإيميلات داخل الرسائل"));
    }

    try {
      final String generatedId = const Uuid().v4();

      final paymentResponse = await supabase
          .from('payments')
          .select('id')
          .eq('order_id', orderId)
          .maybeSingle();

      final paymentId =
      paymentResponse != null ? paymentResponse['id'] as String : null;

      final attachmentJson = message.attachment != null
          ? jsonEncode(message.attachment!.map((e) => e.toJson()).toList())
          : null;

      final insertData = {
        'id': generatedId,
        'order_id': orderId,
        'sender_id': message.senderId,
        'receiver_id': message.receiverId,
        'payment_id': paymentId,
        'message_type': message.messageType,
        'content': message.content,
        'attachment': attachmentJson,
        'status': message.status,
        'created_at': message.createdAt.toIso8601String(),
        'updated_at': message.updatedAt.toIso8601String(),
      };

      final response =
      await supabase.from('messages').insert(insertData).select().single();

      final messageModel = MessageModel.fromJson(response);

      return Right(messageModel);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}
