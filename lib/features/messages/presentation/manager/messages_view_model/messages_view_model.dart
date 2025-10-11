import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/messages/domain/entities/message_entity.dart';
import 'package:taskly/features/messages/domain/use_cases/get_order_messages_use_case/get_order_messages_use_case.dart';
import 'package:taskly/features/messages/domain/use_cases/subscribe_to_messages_use_case/subscribe_to_messages_use_case.dart';

import 'messages_view_model_states.dart';

@injectable
class MessagesViewModel extends Cubit<MessagesStates> {
  final GetOrderMessagesUseCase getMessagesUseCase;
  final SubscribeToMessagesUseCase subscribeToMessagesUseCase;

  MessagesViewModel(this.getMessagesUseCase, this.subscribeToMessagesUseCase)
      : super(MessagesInitial());

  StreamSubscription<(MessageEntity, String)>? _subscription;
  List<MessageEntity> _messages = [];

  /// ✅ تحميل الرسائل القديمة ثم بدء المتابعة اللحظية
  Future<void> loadAndSubscribe(String orderId) async {
    emit(MessagesLoading());

    try {
      // الخطوة 1: تحميل الرسائل القديمة
      final result = await getMessagesUseCase.call(orderId);
      result.fold(
            (failure) => emit(MessagesError(failure: failure)),
            (loadedMessages) {
          _messages = List.from(loadedMessages)
            ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
          emit(MessagesSuccess(messages: _messages));

          // الخطوة 2: بدء الاشتراك في التحديثات
          _startSubscription(orderId);
        },
      );
    } catch (e) {
      emit(MessagesError(failure: ServerFailure(e.toString())));
    }
  }

  /// ✅ بدء متابعة التغييرات اللحظية
  void _startSubscription(String orderId) {
    _subscription?.cancel(); // نلغي أي اشتراك قديم

    _subscription = subscribeToMessagesUseCase.call(orderId).listen(
          (event) {
        final (message, action) = event;

        if (action == 'INSERT') {
          _messages.add(message);
        } else if (action == 'UPDATE') {
          final index = _messages.indexWhere((m) => m.id == message.id);
          if (index != -1) _messages[index] = message;
        } else if (action == 'DELETE') {
          _messages.removeWhere((m) => m.id == message.id);
        }

        _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        emit(MessagesSuccess(messages: List.from(_messages)));
      },
      onError: (error) {
        emit(MessagesError(failure: ServerFailure(error.toString())));
      },
    );
  }

  void unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Future<void> close() {
    unsubscribe();
    return super.close();
  }
}
