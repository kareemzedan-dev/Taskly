import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/domain/use_cases/orders/orders_use_case.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_order_view_model.dart/get_order_view_model_states.dart';
@injectable
class GetOrderViewModel extends Cubit<GetOrderViewModelStates> {
  GetOrderViewModel(this.ordersUseCase) : super(GetOrderViewModelStatesInitial());
  OrdersUseCase ordersUseCase;
  Future<Either<Failures, List<OrderEntity>>> getUserOrdersByUserId(
    String userId,
    String role,
  ) async {
    try {
      emit(GetOrderViewModelStatesLoading());
      var response = await ordersUseCase.callGetUserOrdersByUserId(
        userId,
        role,
      );
      response.fold(
        (fnL) => emit(GetOrderViewModelStatesError(fnL.message)),
        (fnR) => emit(GetOrderViewModelStatesSuccess(fnR)),
      );
      return response;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
