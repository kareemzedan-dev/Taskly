import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/domain/use_cases/freelancer_order_use_case/freelancer_order_use_case.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/cubit/freelancer_pending_order_view_model/freelancer_pending_order_view_model_states.dart';

@injectable
class FreelancerPendingOrdersViewModel
    extends Cubit<FreelancerPendingOrdersState> {
  FreelancerPendingOrdersViewModel(this.freelancerOrderUseCase)
      : super(FreelancerPendingOrdersInitial());

  final FreelancerOrderUseCase freelancerOrderUseCase;

  RealtimeChannel? _ordersChannel;
  Future<Either<Failures, List<OrderEntity>>>
  fetchPendingFreelancerOrders() async {
    try {
      emit(FreelancerPendingOrdersLoading());

      final result =
      await freelancerOrderUseCase.fetchPendingFreelancerOrders( SharedPrefHelper.getString(StringsManager.idKey)!);
      result.fold(
            (failure) => emit(FreelancerPendingOrdersError(failure.message)),
            (orders) {
          emit(FreelancerPendingOrdersSuccess(orders));
          _subscribeRealtime();
        },
      );
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  void _subscribeRealtime() {
    _ordersChannel = freelancerOrderUseCase.subscribeToPendingOrders((
        order,
        action,
        ) {
      if (state is FreelancerPendingOrdersSuccess) {
        final currentOrders = List<OrderEntity>.from(
          (state as FreelancerPendingOrdersSuccess).pendingOrdersList,
        );
if (action.toUpperCase() == 'INSERT') {
  currentOrders.add(order);
} else if (action.toUpperCase() == 'UPDATE') {
  final index = currentOrders.indexWhere((o) => o.id == order.id);
  if (index != -1) {
    currentOrders[index] = order;
  }
} else if (action.toUpperCase() == 'DELETE') {
  currentOrders.removeWhere((o) => o.id == order.id);
}


        emit(FreelancerPendingOrdersSuccess(currentOrders));
      }
    });
  }

  @override
  Future<void> close() {
    if (_ordersChannel != null) {
      _ordersChannel!.unsubscribe();
    }
    return super.close();
  }
}