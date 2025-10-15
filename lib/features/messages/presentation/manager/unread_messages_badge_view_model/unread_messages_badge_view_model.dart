import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/features/messages/presentation/manager/unread_messages_badge_view_model/unread_badge_states.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/use_cases/subscribe_to_messages_use_case/subscribe_to_messages_use_case.dart';
import '../../../domain/use_cases/get_order_messages_use_case/get_order_messages_use_case.dart';
import '../../../../../../../../../core/errors/failures.dart';

@injectable
class UnreadMessagesBadgeViewModel extends Cubit<UnreadMessagesBadgeState> {
  final GetOrderMessagesUseCase getMessagesUseCase;
  final SubscribeToMessagesUseCase subscribeToMessagesUseCase;

  final Map<String, int> _unreadCounts = {}; // 👈 لكل orderId
  final Map<String, StreamSubscription<(MessageEntity, String)>> _subscriptions = {};

  // ✅ اشتراك عام مختلف عن اشتراكات الـ orders
  StreamSubscription<List<MessageEntity>>? _globalSubscription;
  int _globalUnreadCount = 0;

  UnreadMessagesBadgeViewModel(
      this.getMessagesUseCase,
      this.subscribeToMessagesUseCase,
      ) : super(UnreadMessagesBadgeInitial());

  // ✅ الاشتراك العادي لكل orderId
  Future<void> start(String orderId, String currentUserId, String otherUserId) async {
    await _subscriptions[orderId]?.cancel();

    final result = await getMessagesUseCase(orderId, currentUserId, otherUserId);
    result.fold(
          (failure) => emit(UnreadMessagesBadgeError(failure)),
          (messages) {
        _unreadCounts[orderId] = messages
            .where((msg) => msg.receiverId == currentUserId && msg.seenAt == null)
            .length;
        emit(UnreadMessagesBadgeUpdated(Map.from(_unreadCounts)));
      },
    );

    final sub = subscribeToMessagesUseCase(orderId, currentUserId, otherUserId).listen((data) {
      final (message, action) = data;

      if (action == 'INSERT' &&
          message.receiverId == currentUserId &&
          message.seenAt == null) {
        _unreadCounts[orderId] = (_unreadCounts[orderId] ?? 0) + 1;
      } else if (action == 'UPDATE' &&
          message.receiverId == currentUserId &&
          message.seenAt != null) {
        _unreadCounts[orderId] = (_unreadCounts[orderId] ?? 0) > 0
            ? _unreadCounts[orderId]! - 1
            : 0;
      }

      emit(UnreadMessagesBadgeUpdated(Map.from(_unreadCounts)));
    });

    _subscriptions[orderId] = sub;
  }

  // ✅ نسخة عامة تتابع كل الرسائل من كل الطلبات
  Future<void> startGlobal(
      String currentUserId,
      Stream<List<MessageEntity>> Function(String) getAllMessagesStream,
      ) async {
    await _globalSubscription?.cancel();

    _globalSubscription = getAllMessagesStream(currentUserId).listen((messages) {
      _globalUnreadCount = messages
          .where((m) => m.receiverId == currentUserId && m.seenAt == null)
          .length;

      emit(UnreadMessagesBadgeUpdated({'global': _globalUnreadCount}));
    });
  }

  int getUnreadCount(String orderId) => _unreadCounts[orderId] ?? 0;

  int getGlobalUnreadCount() => _globalUnreadCount;

  void markAsRead(String orderId) {
    _unreadCounts[orderId] = 0;
    emit(UnreadMessagesBadgeUpdated(Map.from(_unreadCounts)));
  }

  @override
  Future<void> close() async {
    for (var sub in _subscriptions.values) {
      await sub.cancel();
    }
    await _globalSubscription?.cancel();
    return super.close();
  }
}
