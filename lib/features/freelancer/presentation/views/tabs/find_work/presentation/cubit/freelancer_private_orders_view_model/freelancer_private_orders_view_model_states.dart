import '../../../../../../../../shared/domain/entities/order_entity/order_entity.dart';

class FreelancerPrivateOrdersViewModelStates {}
class FreelancerPrivateOrdersViewModelStatesInitial extends FreelancerPrivateOrdersViewModelStates {}
class FreelancerPrivateOrdersViewModelStatesLoading extends FreelancerPrivateOrdersViewModelStates {}
class FreelancerPrivateOrdersViewModelStatesSuccess extends FreelancerPrivateOrdersViewModelStates {
  final List<OrderEntity> orders;
  FreelancerPrivateOrdersViewModelStatesSuccess({required this.orders});
}
class FreelancerPrivateOrdersViewModelStatesError extends FreelancerPrivateOrdersViewModelStates {
  final String message;
  FreelancerPrivateOrdersViewModelStatesError({required this.message});
}