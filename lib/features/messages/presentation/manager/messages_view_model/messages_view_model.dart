import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../../../../../core/errors/failures.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/use_cases/get_order_messages_use_case/get_order_messages_use_case.dart';
import '../../../domain/use_cases/subscribe_to_messages_use_case/subscribe_to_messages_use_case.dart';
import '../get_messages_view_model/get_messages_view_model_states.dart';
import 'messages_view_model_states.dart';

@injectable
class MessagesViewModel extends Cubit<MessagesStates> {
  final GetOrderMessagesUseCase getMessagesUseCase;
  final SubscribeToMessagesUseCase subscribeToMessagesUseCase;

  MessagesViewModel(this.getMessagesUseCase, this.subscribeToMessagesUseCase)
      : super(MessagesInitial());

  StreamSubscription<(MessageEntity, String)>? _subscription;
  List<MessageEntity> _messages = [];

  /// جلب الرسائل القديمة + الاشتراك في الجديدة
  Future<void> loadAndSubscribeMessages(String orderId, String currentUserId, String otherUserId) async {
    try {
      emit(MessagesLoading());

      // 1️⃣ تحميل الرسائل القديمة
      final result = await getMessagesUseCase.call(orderId, currentUserId, otherUserId);
      result.fold(
            (failure) => emit(MessagesError(failure: failure)),
            (messages) {
          _messages = List.from(messages)
            ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
          emit(MessagesSuccess(messages: _messages));

          // 2️⃣ بعد تحميلها بنبدأ الاشتراك في الجديدة
          _subscribeToMessages(orderId, currentUserId , otherUserId);
        },
      );
    } catch (e) {
      emit(MessagesError(failure: ServerFailure(e.toString())));
    }
  }

  /// الاشتراك في التحديثات اللحظية
  void _subscribeToMessages(String orderId, String currentUserId, String otherUserId) {
    _subscription?.cancel();

    _subscription = subscribeToMessagesUseCase.call(orderId, currentUserId, otherUserId).listen(
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

        // ترتيب حسب الوقت
        _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        emit(MessagesSuccess(messages: List.from(_messages)));
      },
      onError: (error) {
        emit(MessagesError(
            failure: ServerFailure(error.toString())));
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
