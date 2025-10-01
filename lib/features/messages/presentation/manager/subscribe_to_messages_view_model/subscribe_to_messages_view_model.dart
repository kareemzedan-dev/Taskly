import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';
import 'package:taskly/features/messages/domain/use_cases/subscribe_to_messages_use_case/subscribe_to_messages_use_case.dart';
import 'package:taskly/features/messages/presentation/manager/subscribe_to_messages_view_model/subscribe_to_messages_states.dart';
@injectable
class SubscribeToMessagesViewModel extends Cubit<SubscribeToMessagesStates>{
  SubscribeToMessagesViewModel(this.subscribeToMessagesUseCase) : super(SubscribeToMessagesStatesInitial());
  SubscribeToMessagesUseCase subscribeToMessagesUseCase ;
  RealtimeChannel? _messagesChannel;
  Future<void> subscribeToMessages(String orderId) async {
    try {
      _messagesChannel = await subscribeToMessagesUseCase.call(orderId,
          (message, action) {
        final currentMessages = state is SubscribeToMessagesStatesSuccess
            ? List<MessageEntity>.from(
                (state as SubscribeToMessagesStatesSuccess).messages)
            : <MessageEntity>[];
        if (action == 'INSERT') {
          currentMessages.add(message);
        } else if (action == 'UPDATE') {
          final index = currentMessages.indexWhere((m) => m.id == message.id);
          if (index != -1) currentMessages[index] = message;
        } else if (action == 'DELETE') {
          currentMessages.removeWhere((m) => m.id == message.id);
        }

        currentMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        emit(SubscribeToMessagesStatesSuccess(messages: currentMessages));
      });
    } catch (e) {
      emit(SubscribeToMessagesStatesError(
          failure: ServerFailure(e.toString())));
    }
  }

  void unsubscribe() {
    if (_messagesChannel != null) {
      _messagesChannel!.unsubscribe();
      _messagesChannel = null;
    }
  }

}