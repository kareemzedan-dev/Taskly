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
 import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../domain/use_cases/fetch_public_orders_use_case/fetch_public_orders_use_case.dart';
import '../../../../../../../domain/use_cases/subscribe_to_public_orders_use_case/subscribe_to_public_orders_use_case.dart';
import 'freelancer_public_order_states.dart';

@injectable
class FreelancerPublicOrdersViewModel extends Cubit<FreelancerPublicOrdersState> {
  final FetchPublicOrdersUseCase freelancerOrderUseCase;
  final SubscribeToPublicOrdersUseCase subscribeToPublicOrdersUseCase;

  StreamSubscription<List<OrderEntity>>? _ordersSubscription;
  final List<OrderEntity> _currentOrders = [];

  FreelancerPublicOrdersViewModel(
      this.freelancerOrderUseCase,
      this.subscribeToPublicOrdersUseCase
      ) : super(FreelancerPendingOrdersInitial());

  Future<void> fetchAndSubscribePendingOrders() async {
    emit(FreelancerPendingOrdersLoading());

    final freelancerId = SharedPrefHelper.getString(StringsManager.idKey)!;

    // أولاً نجيب الطلبات الحالية
    final result = await freelancerOrderUseCase.fetchPublicOrders(freelancerId);

    final offeredOrderIds = <String>[];
    result.fold(
          (_) {},
          (orders) => offeredOrderIds.addAll(orders.map((o) => o.id)),
    );

    _ordersSubscription = subscribeToPublicOrdersUseCase
        .subscribeToPublicOrders(freelancerId)
        .listen(
          (orders) {
        print("📥 Orders from stream: ${orders.length}");

        _currentOrders
          ..clear()
          ..addAll(
            orders.where((o) => o.serviceType.name.toLowerCase() == 'public'),
          );

        _currentOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        print("✅ After filter: ${_currentOrders.length}");
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

