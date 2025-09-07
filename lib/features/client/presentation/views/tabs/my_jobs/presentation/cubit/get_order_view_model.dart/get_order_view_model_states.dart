import 'package:taskly/domain/entities/order_entity/order_entity.dart';

class GetOrderViewModelStates {}
class GetOrderViewModelStatesInitial extends GetOrderViewModelStates{}
class GetOrderViewModelStatesLoading extends GetOrderViewModelStates{}
class GetOrderViewModelStatesSuccess extends GetOrderViewModelStates{
  final  List<OrderEntity> orderEntity;
  GetOrderViewModelStatesSuccess(this.orderEntity);
}
class GetOrderViewModelStatesError extends GetOrderViewModelStates{
  final String message;
  GetOrderViewModelStatesError(this.message);
}