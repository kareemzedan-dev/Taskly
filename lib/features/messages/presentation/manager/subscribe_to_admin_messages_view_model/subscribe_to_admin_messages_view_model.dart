import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';
import '../../../../attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../../domain/use_cases/subscribe_to_admin_messages_use_case/subscribe_to_admin_messages_use_case.dart';
import 'subscribe_to_admin_messages_states.dart';
@injectable
class SubscribeToAdminMessagesViewModel extends Cubit<SubscribeToAdminMessagesStates> {
  final SubscribeToAdminMessagesUseCase subscribeToAdminMessagesUseCase;
  List<MessageEntity> messages = [];

  SubscribeToAdminMessagesViewModel(this.subscribeToAdminMessagesUseCase)
      : super(SubscribeToAdminMessagesInitial());

  void subscribeToAdminMessages(String currentUserId) async {
    emit(SubscribeToAdminMessagesLoadingState());

    try {
      final channel = await subscribeToAdminMessagesUseCase.subscribeToAdminMessages(currentUserId);

      // نستخدم الـ callback على أي تغيرات
      channel.onPostgresChanges(
        schema: 'public',
        table: 'messages',
        event: PostgresChangeEvent.insert,
        callback: (payload) {
          final data = payload.newRecord;
          if (data != null) {
            final message = MessageEntity(
              id: data['id'],
              orderId: data['order_id'],
              paymentId: data['payment_id'],
              senderId: data['sender_id'],
              receiverId: data['receiver_id'],
              messageType: data['message_type'],
              content: data['content'],
              attachment: data['attachment'] != null
                  ? (data['attachment'] as List).map((a) => AttachmentModel.fromJson(Map<String, dynamic>.from(a))).toList()
                  : null,
              status: data['status'],
              deliveredAt: data['delivered_at'] != null ? DateTime.tryParse(data['delivered_at']) : null,
              seenAt: data['seen_at'] != null ? DateTime.tryParse(data['seen_at']) : null,
              createdAt: DateTime.parse(data['created_at']),
              updatedAt: DateTime.parse(data['updated_at']),
            );

            messages.add(message);
            emit(SubscribeToAdminMessagesSuccessState(messages));
          }
        },
      ).subscribe();
    } catch (e) {
      emit(SubscribeToAdminMessagesErrorState(ServerFailure(e.toString())));
    }
  }

  void unsubscribe() {
    messages.clear();
    emit(SubscribeToAdminMessagesInitial());
  }
}
