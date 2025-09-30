import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

import '../../../../../../../domain/use_cases/my_jobs/subscribe_to_orders_use_case/subscribe_to_orders_use_case.dart';
import 'client_order_status_states.dart';

@injectable
class ClientOrderStatusViewModel extends Cubit<OrderStatusState> {
  final SubscribetToOrdersUseCase clientOrderUseCase;
  RealtimeChannel? _orderChannel;

  ClientOrderStatusViewModel(this.clientOrderUseCase)
      : super(OrderStatusInitial());

  void subscribeToOrder(String orderId) {
    _orderChannel = clientOrderUseCase.subscribeToOrders(
      {'id': orderId},
          (order, action) {
        emit(OrderStatusUpdated(order));
      },
    );
  }

  @override
  Future<void> close() {
    _orderChannel?.unsubscribe();
    return super.close();
  }
}