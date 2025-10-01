import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/domain/use_cases/fetch_private_orders_use_case/fetch_private_orders_use_case.dart';
import 'freelancer_private_orders_view_model_states.dart';

@injectable
class FreelancerPrivateOrdersViewModel
    extends Cubit<FreelancerPrivateOrdersViewModelStates> {
  final FetchPrivateOrdersUseCase fetchPrivateOrdersUseCase;
  StreamSubscription<(OrderEntity, String)>? _ordersSubscription;

  FreelancerPrivateOrdersViewModel(this.fetchPrivateOrdersUseCase)
      : super(FreelancerPrivateOrdersViewModelStatesInitial());

  Future<Either<Failures, List<OrderEntity>>> fetchPrivateOrders(String freelancerId) async {
    try {
      emit(FreelancerPrivateOrdersViewModelStatesLoading());

      final result = await fetchPrivateOrdersUseCase.call(freelancerId);

      result.fold(
            (failure) => emit(FreelancerPrivateOrdersViewModelStatesError(message: failure.message)),
            (orders) {
          emit(FreelancerPrivateOrdersViewModelStatesSuccess(orders: orders));
          _subscribeToPrivateOrders(freelancerId);
        },
      );

      return result;
    } catch (e) {
      final failure = Failures(e.toString());
      emit(FreelancerPrivateOrdersViewModelStatesError(message: failure.message));
      return Left(failure);
    }
  }
  void _subscribeToPrivateOrders(String freelancerId) {
    _ordersSubscription?.cancel();

    _ordersSubscription =
        fetchPrivateOrdersUseCase.subscribeRealtime(freelancerId).listen(
              (event) {
            final order = event.$1;
            final action = event.$2;

            if (order.serviceType.name != 'private' || order.freelancerId != freelancerId) return;

            final currentState = state;
            if (currentState is FreelancerPrivateOrdersViewModelStatesSuccess) {
              var updatedOrders = List<OrderEntity>.from(currentState.orders);

              switch (action.toUpperCase()) {
                case 'INSERT':
                  if (!updatedOrders.any((o) => o.id == order.id)) {
                    updatedOrders.insert(0, order); // INSERT فوق مباشرة
                  }
                  break;
                case 'UPDATE':
                  final index = updatedOrders.indexWhere((o) => o.id == order.id);
                  if (index != -1) {
                    updatedOrders[index] = order;
                  }
                  break;
                case 'DELETE':
                  updatedOrders.removeWhere((o) => o.id == order.id);
                  break;
              }

              // ترتيب حسب createdAt دايمًا
              updatedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

              emit(FreelancerPrivateOrdersViewModelStatesSuccess(orders: updatedOrders));
            } else if (currentState is FreelancerPrivateOrdersViewModelStatesInitial) {
              emit(FreelancerPrivateOrdersViewModelStatesSuccess(orders: [order]));
            }
          },
          onError: (error) {
            emit(FreelancerPrivateOrdersViewModelStatesError(
                message: 'Real-time subscription error: $error'));
          },
        );
  }


  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
