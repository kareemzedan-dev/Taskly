import 'package:taskly/features/client/domain/entities/home/order_entity.dart';

class OrderViewModelStates {}

class OrderViewModelStatesInitial extends OrderViewModelStates {}

class OrderViewModelStatesLoading extends OrderViewModelStates {}

class OrderViewModelStatesError extends OrderViewModelStates {
  final String message;

  OrderViewModelStatesError(this.message);
}

class OrderViewModelStatesSuccess extends OrderViewModelStates {
  final OrderEntity orderEntity;

  OrderViewModelStatesSuccess(this.orderEntity);
}

class OrderViewModelStatesAttachmentsLoading extends OrderViewModelStates {}

class OrderViewModelStatesAttachmentsSuccess extends OrderViewModelStates {
  final List<Attachment> attachments;
  OrderViewModelStatesAttachmentsSuccess(this.attachments);
}

class OrderViewModelStatesAttachmentsError extends OrderViewModelStates {
  final String message;
  OrderViewModelStatesAttachmentsError(this.message);
}
