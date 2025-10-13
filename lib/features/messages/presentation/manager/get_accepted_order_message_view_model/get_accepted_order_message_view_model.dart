import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/messages/domain/use_cases/get_accepted_order_message_use_case/get_accepted_order_message_use_case.dart';

import '../../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../../../welcome/presentation/cubit/welcome_states.dart';
import 'get_accepted_order_message_states.dart';

@injectable
class GetAcceptedOrderMessageViewModel
    extends Cubit<GetAcceptedOrderMessageStates> {
  GetAcceptedOrderMessageViewModel(this.getAcceptedOrderMessagesUseCase)
      : super(GetAcceptedOrderMessageStatesInitial());

  final GetAcceptedOrderMessagesUseCase getAcceptedOrderMessagesUseCase;
  Stream<List<OrderEntity>>? _ordersStream;
  StreamSubscription<List<OrderEntity>>? _ordersSubscription;

  Future<void> getAcceptedOrderMessages(
      String userId, {
        UserRole? role,
      }) async {
    try {
      emit(GetAcceptedOrderMessageStatesLoading());

      // 1️⃣ fetch الحالي
      final fetchResult = await getAcceptedOrderMessagesUseCase(userId, role: role);
      List<OrderEntity> currentOrders = [];
      fetchResult.fold(
            (failure) =>
            emit(GetAcceptedOrderMessageStatesError(message: failure.message)),
            (orders) {
          currentOrders = orders;
          emit(GetAcceptedOrderMessageStatesSuccess(orders: currentOrders));
        },
      );

      // 2️⃣ الاشتراك على التغييرات الجديدة
      _ordersSubscription?.cancel();
      _ordersStream =
          getAcceptedOrderMessagesUseCase.subscribeToAcceptedOrders(userId, role: role);

      _ordersSubscription = _ordersStream!.listen((updatedOrders) {
        // دمج أي تحديثات جديدة مع الأوردرات الحالية
        final mergedOrders = [
          ...currentOrders.where((o) =>
          !updatedOrders.any((u) => u.id == o.id)),
          ...updatedOrders
        ];

        currentOrders = mergedOrders;
        emit(GetAcceptedOrderMessageStatesSuccess(orders: mergedOrders));
      });
    } catch (e) {
      emit(GetAcceptedOrderMessageStatesError(message: e.toString()));
    }
  }


  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
