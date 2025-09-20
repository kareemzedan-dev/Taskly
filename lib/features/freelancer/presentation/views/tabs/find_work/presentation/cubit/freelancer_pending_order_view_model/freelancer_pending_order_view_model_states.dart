import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

class FreelancerPendingOrdersState {}

class FreelancerPendingOrdersInitial extends FreelancerPendingOrdersState {}

class FreelancerPendingOrdersLoading extends FreelancerPendingOrdersState {}

class FreelancerPendingOrdersError extends FreelancerPendingOrdersState {
  final String errorMessage;
  FreelancerPendingOrdersError(this.errorMessage);
}

class FreelancerPendingOrdersEmpty extends FreelancerPendingOrdersState {}

class FreelancerPendingOrdersSuccess extends FreelancerPendingOrdersState {
  final List<OrderEntity> pendingOrdersList;
  FreelancerPendingOrdersSuccess(this.pendingOrdersList);
}