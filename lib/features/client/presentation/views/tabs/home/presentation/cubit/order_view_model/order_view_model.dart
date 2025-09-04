import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/features/client/domain/entities/home/order_entity.dart';
import 'package:taskly/features/client/domain/use_cases/home/home_use_case.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/order_view_model/order_view_model_states.dart';
@injectable
class OrderViewModel extends Cubit<OrderViewModelStates> {
  HomeUseCase homeUseCase;
  OrderViewModel(this.homeUseCase) : super(OrderViewModelStatesInitial());
  Future<Either<Failures, OrderEntity>> placeOrder(
    OrderEntity orderEntity,
  ) async {
    try {
      emit(OrderViewModelStatesLoading());
      final result = await homeUseCase.callPlaceOrder(orderEntity);
      result.fold(
        (failure) => emit(OrderViewModelStatesError(failure.message)),
        (order) => emit(OrderViewModelStatesSuccess(order)),
      );
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
