import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/features/freelancer/domain/use_cases/update_order_status_use_case/update_order_status_use_case.dart';
import 'package:taskly/features/freelancer/presentation/cubit/update_order_status_view_model/update_order_status_states.dart';
@injectable
class UpdateOrderStatusViewModel extends Cubit<UpdateOrderStatusStates>{
  UpdateOrderStatusViewModel(this.updateOrderStatusUseCase) : super(UpdateOrderStatusInitial());
  UpdateOrderStatusUseCase updateOrderStatusUseCase ;

  Future<void> updateOrderStatus(String orderId , String status)async{
    emit(UpdateOrderStatusLoading());
    var result = await updateOrderStatusUseCase.call(orderId, status);
    result.fold((failure) => emit(UpdateOrderStatusError(failure.message)), 
    (order) => emit(UpdateOrderStatusSuccess("Order status updated successfully")));
  }
}