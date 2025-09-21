import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/freelancer/domain/use_cases/fetch_private_orders_use_case/fetch_private_orders_use_case.dart';
import 'package:taskly/features/shared/data/models/order_dm/order_dm.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

import 'freelancer_private_orders_view_model_states.dart';

@injectable
class FreelancerPrivateOrdersViewModel
    extends Cubit<FreelancerPrivateOrdersViewModelStates> {
  final FetchPrivateOrdersUseCase fetchPrivateOrdersUseCase;

  FreelancerPrivateOrdersViewModel(this.fetchPrivateOrdersUseCase)
    : super(FreelancerPrivateOrdersViewModelStatesInitial());

  /// تحميل أولي
  Future<Either<Failures, List<OrderEntity>>> fetchPrivateOrders(
    String freelancerId,
  ) async {
    try {
      emit(FreelancerPrivateOrdersViewModelStatesLoading());
      final result = await fetchPrivateOrdersUseCase.call(freelancerId);
      result.fold(
        (l) => emit(
          FreelancerPrivateOrdersViewModelStatesError(message: l.message),
        ),
        (r) {
          emit(FreelancerPrivateOrdersViewModelStatesSuccess(orders: r));
          subscribeToPrivateOrders(
            freelancerId,
                (order, action) {
              final currentState = state;
              if (currentState is FreelancerPrivateOrdersViewModelStatesSuccess) {
                var updatedOrders = List<OrderEntity>.from(currentState.orders);

                switch (action) {
                  case 'INSERT':
                    updatedOrders.add(order);
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

                emit(FreelancerPrivateOrdersViewModelStatesSuccess(
                  orders: updatedOrders,
                ));
              }
            },
          );

        },
      );
      return result;
    } catch (e) {
      final failure = Failures(e.toString());
      emit(
        FreelancerPrivateOrdersViewModelStatesError(message: failure.message),
      );
      return Left(failure);
    }
  }
  RealtimeChannel subscribeToPrivateOrders(
      String freelancerId,
      void Function(OrderEntity, String) onChange,
      ) {
    return Supabase.instance.client
        .channel('private:orders_$freelancerId')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'orders',
      filter: PostgresChangeFilter(
        type:   PostgresChangeFilterType.eq,
        column: 'freelancer_id',
        value: freelancerId,
      ),
      callback: (payload) {
        final action = payload.eventType.name.toUpperCase();
        final order = OrderDm.fromJson(payload.newRecord!);
        onChange(order, action);
      },
    )
        .subscribe();
  }

}
