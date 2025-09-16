
import 'package:taskly/domain/entities/order_entity/order_entity.dart';

class PlaceOrderViewModelStates {}

class PlaceOrderViewModelStatesInitial extends PlaceOrderViewModelStates {}

class PlaceOrderViewModelStatesLoading extends PlaceOrderViewModelStates {}

class PlaceOrderViewModelStatesError extends PlaceOrderViewModelStates {
  final String message;

  PlaceOrderViewModelStatesError(this.message);
}

class PlaceOrderViewModelStatesSuccess extends PlaceOrderViewModelStates {
  final OrderEntity orderEntity;

  PlaceOrderViewModelStatesSuccess(this.orderEntity);
}
