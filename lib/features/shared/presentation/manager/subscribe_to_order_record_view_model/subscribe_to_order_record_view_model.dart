import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/services/notification_service.dart';
import 'package:taskly/features/shared/domain/use_cases/orders/orders_use_case.dart';
import 'package:taskly/features/shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_states.dart';
import '../../../domain/entities/order_entity/order_entity.dart';

@injectable
class SubscribeOrdersRecordViewModel extends Cubit<OrderViewModelState> {
  final OrdersUseCase subscribeOrderUseCase;
  StreamSubscription? _subscription;

  // Map للاحتفاظ بالحالات التي تم إرسال الإشعار لها بالفعل لكل order
  final Map<String, Set<OrderStatus>> _sentNotifications = {};

  SubscribeOrdersRecordViewModel({required this.subscribeOrderUseCase})
      : super(OrderInitial());

  void subscribe(String orderId) {
    emit(OrderLoading());
    _subscription?.cancel();
    _subscription = subscribeOrderUseCase
        .callSubscribeToOrder(orderId)
        .listen((order) {
      print("Realtime update received: ${order.id} - ${order.status}");

      // ارسال notification بناءً على الحالة
      _handleNotifications(order);

      emit(OrderSuccess(order));
    }, onError: (error) {
      print("Error in subscription: $error");
      emit(OrderError(error.toString()));
    });
  }

  void _handleNotifications(OrderEntity order) {
     _sentNotifications.putIfAbsent(order.id, () => {});

    if (_sentNotifications[order.id]!.contains(order.status)) return;

    switch (order.status) {
      case OrderStatus.InProgress:
        _sendToBoth(
          order,
          "Order Started",
          "🎉 Your order '${order.title}' has been confirmed. You can start working now!",
        );
        break;
      case OrderStatus.Waiting:
        _sendToClient(
          order,
          "Work Submitted",
          "✅ Your order '${order.title}' has been submitted by the freelancer. Please review and confirm delivery.",
        );
        break;
      case OrderStatus.Completed:
        _sendToBoth(
          order,
          "Order Completed",
          "🎉 Your order '${order.title}' has been completed successfully!",
        );
        break;
      case OrderStatus.Cancelled:
        _sendToBoth(
          order,
          "Order Cancelled",
          "⚠️ Your order '${order.title}' has been cancelled.",
        );
        break;
      default:
        break; // Pending, Accepted, Paid أو أي حالة غير مهمة لا نرسل لها إشعار
    }

    // علمنا ان الإشعار للحالة دي اتبعت
    _sentNotifications[order.id]!.add(order.status);
  }

  void _sendToBoth(OrderEntity order, String title, String body) {
    NotificationService().sendNotification(
      receiverId: order.freelancerId!,
      title: title,
      body: body,
    );
    NotificationService().sendNotification(
      receiverId: order.clientId,
      title: title,
      body: body,
    );
  }

  void _sendToClient(OrderEntity order, String title, String body) {
    NotificationService().sendNotification(
      receiverId: order.clientId,
      title: title,
      body: body,
    );
  }

  String getAdminMessage(OrderEntity order) {
    switch (order.status) {
      case OrderStatus.Pending:
        return "System: The order is still pending. No offer has been accepted yet.";
      case OrderStatus.Accepted:
        return "System: The offer has been accepted. Waiting for payment before work can start.";
      case OrderStatus.Paid:
        return "System: Payment has been submitted and is under review. Work will begin as soon as possible.";
      case OrderStatus.InProgress:
        return "System: Order payment has been confirmed, you can start working on it now.";
      case OrderStatus.Waiting:
        return "System: Work has been submitted to the client for review.";
      case OrderStatus.Completed:
        return "System: The order has been completed successfully.";
      case OrderStatus.Cancelled:
        return "System: This order has been cancelled.";
      default:
        return "Order status unknown.";
    }
  }

  String? getActionButtonText(OrderEntity order, String currentUserId) {
    switch (order.status) {
      case OrderStatus.Pending:
        return null;
      case OrderStatus.Accepted:
        if (currentUserId == order.clientId) return "Pay Now ${order.budget}SAR";
        return null;
      case OrderStatus.InProgress:
        if (currentUserId == order.freelancerId) return "Submit Delivery";
        return null;
      case OrderStatus.Waiting:
        if (currentUserId == order.clientId) return "Work Received";
        return null;
      default:
        return null;
    }
  }

  bool shouldShowButton(OrderEntity order, String currentUserId) {
    return getActionButtonText(order, currentUserId) != null;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
