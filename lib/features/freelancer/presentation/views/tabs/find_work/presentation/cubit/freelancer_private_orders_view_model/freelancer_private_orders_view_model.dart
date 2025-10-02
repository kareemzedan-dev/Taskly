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
  StreamSubscription<List<OrderEntity>>? _ordersSubscription;

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
              (orders) {
            // الفلترة: نخلي بس الأوردرات اللي تخص الفريلانسر و private
            final filteredOrders = orders
                .where((o) =>
            o.serviceType.name == 'private' &&
                o.freelancerId == freelancerId)
                .toList();

            // ترتيب حسب التاريخ
            filteredOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            // اعمل Emit دايمًا بالقائمة الجديدة
            emit(FreelancerPrivateOrdersViewModelStatesSuccess(
                orders: List.from(filteredOrders)));
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
