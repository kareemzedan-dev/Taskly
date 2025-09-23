import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/messages/presentation/manager/get_messages_view_model/get_messages_view_model_states.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/use_cases/get_order_messages_use_case/get_order_messages_use_case.dart';

class GetMessagesViewModel extends Cubit<GetMessagesViewModelStates> {
  final GetOrderMessagesUseCase getOrderMessagesUseCase;

  GetMessagesViewModel(this.getOrderMessagesUseCase) : super(GetMessagesViewModelStatesInitial());

  RealtimeChannel? _messagesChannel;

  Future<void> getOrderMessages(String orderId) async {
    try {
      emit(GetMessagesViewModelStatesLoading());
      final result = await getOrderMessagesUseCase.call(orderId);
      result.fold(
            (failure) => emit(GetMessagesViewModelStatesError(failure: failure)),
            (messages) => emit(GetMessagesViewModelStatesSuccess(messages: messages)),
      );
    } catch (e) {
      emit(GetMessagesViewModelStatesError(failure: ServerFailure(e.toString())));
    }
  }

  Future<void> subscribeToMessages(String orderId) async {
    try {
      _messagesChannel = await getOrderMessagesUseCase.callSubscribe(orderId, (message, action) {
        final currentMessages = state is GetMessagesViewModelStatesSuccess
            ? List<MessageEntity>.from((state as GetMessagesViewModelStatesSuccess).messages)
            : <MessageEntity>[];

        if (action == 'INSERT') {
          currentMessages.add(message);
        } else if (action == 'UPDATE') {
          final index = currentMessages.indexWhere((m) => m.id == message.id);
          if (index != -1) currentMessages[index] = message;
        } else if (action == 'DELETE') {
          currentMessages.removeWhere((m) => m.id == message.id);
        }

        emit(GetMessagesViewModelStatesSuccess(messages: currentMessages));

      });
    } catch (e) {
      emit(GetMessagesViewModelStatesError(failure: ServerFailure(e.toString())));
    }
  }

  void unsubscribe() {
    if (_messagesChannel != null) {
      _messagesChannel!.unsubscribe();
      _messagesChannel = null;
    }
  }
}
