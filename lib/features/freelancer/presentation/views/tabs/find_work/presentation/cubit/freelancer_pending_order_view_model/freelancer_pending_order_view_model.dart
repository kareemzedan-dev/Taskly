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
  StreamSubscription<List<OrderEntity>>? _ordersSubscription;

  Future<Either<Failures, List<OrderEntity>>>
      fetchPendingFreelancerOrders() async {
    try {
      emit(FreelancerPendingOrdersLoading());

      final result = await freelancerOrderUseCase.fetchPendingFreelancerOrders(
        SharedPrefHelper.getString(StringsManager.idKey)!,
      );

      result.fold(
        (failure) => emit(FreelancerPendingOrdersError(failure.message)),
        (orders) {
          emit(FreelancerPendingOrdersSuccess(orders));
          _subscribeRealtime(); // هنا تناديه
        },
      );

      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  void _subscribeRealtime() {
    _ordersSubscription =
        freelancerOrderUseCase.subscribeToPendingOrders().listen((orders) {
      emit(FreelancerPendingOrdersSuccess(orders));
    });
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}

