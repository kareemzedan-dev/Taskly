import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';
import '../../../data_sources/remote/send_to_admin_messages_remote_data_source/send_to_admin_messages_remote_data_source.dart';
import '../../../models/message_model.dart';
@Injectable(as:  SendToAdminMessagesRemoteDataSource)
class SendToAdminMessagesRemoteDataSourceImpl
    implements SendToAdminMessagesRemoteDataSource {

  final SupabaseClient supabase;

  SendToAdminMessagesRemoteDataSourceImpl(this.supabase);
  @override
  Future<Either<Failures, void>> SendToAdminMessage({required MessageEntity message}) async {
    try {
      String adminId = message.receiverId.isNotEmpty ? message.receiverId : '';

      if (adminId.isEmpty) {
        final response = await supabase
            .from('admins')
            .select('id')
            .limit(1);
        final data = response as List;
        if (data.isEmpty) {
          return Left(ServerFailure("No admin found"));
        }
        adminId = data.first['id'] as String;
      }

      final adminMessage = await MessageModel.toAdminMessage(

        senderId: message.senderId,
        senderType: message.senderType,
        content: message.content,
        attachments: message is MessageModel ? message.attachment : null,
        orderId: message.orderId,
        paymentId: message.paymentId,
        adminId: adminId,
      );

      print("Sending admin message: ${adminMessage.toJson()}"); // debug

      await supabase.from('messages').insert([adminMessage.toJson()]);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}
