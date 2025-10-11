import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../../data_sources/remote/get_admin_messages_remote_data_source/get_admin_messages_remote_data_source.dart';
@Injectable(as: GetAdminMessagesRemoteDataSource)
class GetAdminMessagesRemoteDataSourceImpl implements GetAdminMessagesRemoteDataSource {
  final SupabaseService supabaseService;

  GetAdminMessagesRemoteDataSourceImpl(this.supabaseService);
  @override
  Future<Either<Failures, List<MessageEntity>>> getAdminMessages(String currentUserId) async {
    try {
      // جلب أول admin فقط
      final adminsResponse = await supabaseService.supabaseClient
          .from('admins')
          .select('id')
          .limit(1);

      if ((adminsResponse as List).isEmpty) return const Right([]);

      final firstAdminId = adminsResponse.first['id'].toString();

      final response = await supabaseService.supabaseClient
          .from('messages')
          .select()
          .or('and(sender_id.eq.$currentUserId,receiver_id.eq.$firstAdminId),and(sender_id.eq.$firstAdminId,receiver_id.eq.$currentUserId)')
          .order('created_at', ascending: true);


      final messages = (response as List).map((msg) {
        final data = Map<String, dynamic>.from(msg as Map);
        return MessageEntity(
          id: data['id'],
          orderId: data['order_id'],
          paymentId: data['payment_id'],
          senderId: data['sender_id'],
          receiverId: data['receiver_id'],
          messageType: data['message_type'],
          content: data['content'],
          attachment: data['attachment'] != null
              ? (data['attachment'] as List)
              .map((a) => AttachmentModel.fromJson(Map<String, dynamic>.from(a)))
              .toList()
              : null,
          status: data['status'],
          deliveredAt: data['delivered_at'] != null ? DateTime.tryParse(data['delivered_at']) : null,
          seenAt: data['seen_at'] != null ? DateTime.tryParse(data['seen_at']) : null,
          createdAt: DateTime.parse(data['created_at']),
          updatedAt: DateTime.parse(data['updated_at']),
          senderType: data['sender_type'],
          receiverType: data['receiver_type'],
        );
      }).toList();

      return Right(messages);
    } catch (e, st) {
      print('Error in GetAdminMessagesRemoteDataSourceImpl: $e\n$st');
      return const Right([]);
    }
  }

}
