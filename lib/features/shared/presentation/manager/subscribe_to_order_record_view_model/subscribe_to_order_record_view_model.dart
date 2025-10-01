import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/features/shared/domain/use_cases/orders/orders_use_case.dart';
import 'package:taskly/features/shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_states.dart';

import '../../../domain/entities/order_entity/order_entity.dart';

@injectable
class SubscribeOrdersRecordViewModel extends Cubit<OrderViewModelState> {
  final OrdersUseCase subscribeOrderUseCase;
  StreamSubscription? _subscription;

  SubscribeOrdersRecordViewModel({required this.subscribeOrderUseCase})
      : super(OrderInitial());

  void subscribe(String orderId) {
    emit(OrderLoading());
    _subscription?.cancel();
    _subscription = subscribeOrderUseCase.callSubscribeToOrder(orderId).listen(
          (order) {
        print("Realtime update received: ${order.id} - ${order.status}");
        emit(OrderSuccess(order));
      },
      onError: (error) {
        print("Error in subscription: $error");
        emit(OrderError(error.toString()));
      },
    );

  }
  String getAdminMessage(OrderEntity order) {
    switch (order.status) {
      case OrderStatus.Pending:
        return "System: The order is still pending. No offer has been accepted yet.";
      case OrderStatus.Accepted:
        return "System:The offer has been accepted. Waiting for payment before work can start.";
      case OrderStatus.Paid:

        return "System:Payment has been submitted and is under review. Work will begin as soon as possible.";
      case OrderStatus.InProgress:
        return "System:Order payment has been confirmed, you can start working on it now.";
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
        if (currentUserId == order.freelancerId) return "Submit Work";
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
