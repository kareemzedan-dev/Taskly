import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';
import '../../../domain/use_cases/subscribe_to_admin_messages_use_case/subscribe_to_admin_messages_use_case.dart';
import 'subscribe_to_admin_messages_states.dart';

@injectable
class SubscribeToAdminMessagesViewModel extends Cubit<SubscribeToAdminMessagesStates> {
  final SubscribeToAdminMessagesUseCase subscribeToAdminMessagesUseCase;
  List<MessageEntity> messages = [];

  SubscribeToAdminMessagesViewModel(this.subscribeToAdminMessagesUseCase)
      : super(SubscribeToAdminMessagesInitial());

  void subscribeToAdminMessages(
      String currentUserId,
      void Function(MessageEntity message, String action)? onChange,
      ) async {
    emit(SubscribeToAdminMessagesLoadingState());

    try {
      final channel = await subscribeToAdminMessagesUseCase.subscribeToAdminMessages(
        currentUserId,
            (message, action) {
          // إضافة الرسالة للقائمة لو مش موجودة بالفعل
          if (!messages.any((m) => m.id == message.id)) {
            messages.add(message);
            emit(SubscribeToAdminMessagesSuccessState(List.from(messages))); // clone للقائمة لتحديث UI
          }

          // استدعاء callback خارجي لو موجود
          if (onChange != null) {
            onChange(message, action);
          }
        },
      );

      // اشتراك آمن مع حماية ضد null
      channel.subscribe();
    } catch (e) {
      emit(SubscribeToAdminMessagesErrorState(ServerFailure(e.toString())));
    }
  }

  void unsubscribe() {
    messages.clear();
    emit(SubscribeToAdminMessagesInitial());
  }
}
