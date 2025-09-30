import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/client/domain/use_cases/my_jobs/subscribe_to_order_status_use_case/subscribe_to_order_status_use_case.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/shared/domain/use_cases/orders/orders_use_case.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/get_order_view_model.dart/get_order_view_model_states.dart';

@injectable
class GetOrderViewModel extends Cubit<GetOrderViewModelStates> {
  GetOrderViewModel(this.ordersUseCase, this.myJobsUseCases)
      : super(GetOrderViewModelStatesInitial());

  final OrdersUseCase ordersUseCase;
  final SubscribeToOrderStatusUseCase myJobsUseCases;

  RealtimeChannel? _ordersChannel;


  Future<Either<Failures, List<OrderEntity>>> getUserOrdersByUserId(
      String userId,
      String role,) async {
    try {
      emit(GetOrderViewModelStatesLoading());
      var response = await ordersUseCase.callGetUserOrdersByUserId(
        userId,
        role,
      );
      response.fold(
            (fnL) => emit(GetOrderViewModelStatesError(fnL.message)),
            (fnR) => emit(GetOrderViewModelStatesSuccess(fnR)),
      );
      return response;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  RealtimeChannel subscribeToOrderStatus({
    required Map<String, String> filters,
    required void Function(OrderEntity order, String action) onChange,
  }) {
    _ordersChannel = myJobsUseCases.subscribeToOrderStatus(
     filters:  filters,
       onChange:    (order, action) {
        if (action == 'UPDATE') {
          emit(GetOrderViewModelStatesOrderUpdated(order));
        } else if (action == 'DELETE') {
          emit(GetOrderViewModelStatesOrderDeleted(order.id));
        } else if (action == 'INSERT') {
          emit(GetOrderViewModelStatesOrderInserted(order));
        }
      },
    );
    return _ordersChannel!;
  }

  Future<void> loadAndSubscribeOrders(String userId, String role) async {
    final response = await getUserOrdersByUserId(userId, role);
    response.fold(
          (l) {},
          (orders) {
        subscribeToOrderStatus(
          filters: {'client_id': userId},
          onChange: (order, action) {
          },
        );
      },
    );
  }


}
