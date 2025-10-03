import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/domain/use_cases/subscribe_to_private_orders_use_case/subscribe_to_private_orders_use_case.dart';
import 'freelancer_private_orders_view_model_states.dart';

@injectable
class FreelancerPrivateOrdersViewModel 
    extends Cubit<FreelancerPrivateOrdersViewModelStates> {
  
  final SubscribeToPrivateOrdersUseCase subscribeToPrivateOrdersUseCase;
  StreamSubscription<List<OrderEntity>>? _ordersSubscription;
  String? _currentFreelancerId;

  FreelancerPrivateOrdersViewModel(
    this.subscribeToPrivateOrdersUseCase,
  ) : super(FreelancerPrivateOrdersViewModelStatesInitial());

  Future<void> fetchAndSubscribePrivateOrders(String freelancerId) async {
    try {
      emit(FreelancerPrivateOrdersViewModelStatesLoading());
      _currentFreelancerId = freelancerId;

      // إلغاء أي subscription سابق
      _ordersSubscription?.cancel();

      // البدء في الاستماع للتحديثات
      _ordersSubscription = subscribeToPrivateOrdersUseCase
          .subscribeToPrivateOrders(freelancerId)
          .listen(
            _handleOrdersUpdate,
            onError: (error) {
              emit(FreelancerPrivateOrdersViewModelStatesError(
                message: 'Real-time subscription error: $error'
              ));
            },
          );

    } catch (e) {
      final failure = Failures(e.toString());
      emit(FreelancerPrivateOrdersViewModelStatesError(
        message: failure.message
      ));
    }
  }

  void _handleOrdersUpdate(List<OrderEntity> orders) {
    if (_currentFreelancerId == null) return;

    // تصفية الـ orders لهذا الـ freelancer
    final filteredOrders = orders.where((order) =>
      order.serviceType.name.toLowerCase() == 'private' &&
      order.freelancerId == _currentFreelancerId
    ).toList();

    // ترتيب حسب التاريخ (الأحدث أولاً)
    filteredOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    emit(FreelancerPrivateOrdersViewModelStatesSuccess(
      orders: filteredOrders
    ));
  }

  // دالة لـ refresh البيانات يدوياً
  Future<void> refreshOrders() async {
    if (_currentFreelancerId != null) {
      await fetchAndSubscribePrivateOrders(_currentFreelancerId!);
    }
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}