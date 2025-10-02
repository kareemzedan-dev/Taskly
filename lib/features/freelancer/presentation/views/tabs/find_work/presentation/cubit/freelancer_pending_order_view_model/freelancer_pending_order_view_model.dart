import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/shared/data/models/order_dm/order_dm.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/domain/use_cases/freelancer_order_use_case/freelancer_order_use_case.dart';
import 'freelancer_pending_order_view_model_states.dart';

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/domain/use_cases/freelancer_order_use_case/freelancer_order_use_case.dart';
import 'freelancer_pending_order_view_model_states.dart';

@injectable
class FreelancerPendingOrdersViewModel extends Cubit<FreelancerPendingOrdersState> {
  final FreelancerOrderUseCase freelancerOrderUseCase;
  StreamSubscription<List<OrderEntity>>? _ordersSubscription;
  final List<OrderEntity> _currentOrders = [];

  FreelancerPendingOrdersViewModel(this.freelancerOrderUseCase)
      : super(FreelancerPendingOrdersInitial());

  Future<Either<Failures, List<OrderEntity>>> fetchPendingFreelancerOrders() async {
    emit(FreelancerPendingOrdersLoading());

    final freelancerId = SharedPrefHelper.getString(StringsManager.idKey)!;

    final result = await freelancerOrderUseCase.fetchPendingFreelancerOrders(freelancerId);

    result.fold(
          (failure) => emit(FreelancerPendingOrdersError(failure.message)),
          (orders) {
        _currentOrders
          ..clear()
          ..addAll(orders);
        emit(FreelancerPendingOrdersSuccess(List.from(_currentOrders)));
        _subscribeToPendingOrders(freelancerId);
      },
    );

    return result;
  }
  void _subscribeToPendingOrders(String freelancerId) async {
    _ordersSubscription?.cancel();

    final offersResponse = await freelancerOrderUseCase.fetchPendingFreelancerOrders(freelancerId);
    final offeredOrderIds = <String>[];
    offersResponse.fold(
          (_) {},
          (orders) => offeredOrderIds.addAll(orders.map((o) => o.id)),
    );
    _ordersSubscription = freelancerOrderUseCase
        .subscribeToPendingOrders(freelancerId)
        .listen(
          (orders) {
        _currentOrders
          ..clear()
          ..addAll(
            orders.where((o) =>
            o.serviceType.name == 'public' &&
                !offeredOrderIds.contains(o.id)),
          );

        // رتبهم حسب التاريخ
        _currentOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // اعمل emit على طول
        emit(FreelancerPendingOrdersSuccess(List.from(_currentOrders)));
      },
      onError: (error) {
        emit(FreelancerPendingOrdersError('Real-time subscription error: $error'));
      },
    );

  }


  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
