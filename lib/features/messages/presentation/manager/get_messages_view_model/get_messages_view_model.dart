import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/messages/presentation/manager/get_messages_view_model/get_messages_view_model_states.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/use_cases/get_order_messages_use_case/get_order_messages_use_case.dart';

@injectable
class GetMessagesViewModel extends Cubit<GetMessagesViewModelStates> {
  final GetOrderMessagesUseCase getOrderMessagesUseCase;

  GetMessagesViewModel(this.getOrderMessagesUseCase)
      : super(GetMessagesViewModelStatesInitial());

 

  Future<void> getOrderMessages(String orderId) async {
    try {
      emit(GetMessagesViewModelStatesLoading());
      final result = await getOrderMessagesUseCase.call(orderId);
      result.fold(
        (failure) => emit(GetMessagesViewModelStatesError(failure: failure)),
        (messages) =>
            emit(GetMessagesViewModelStatesSuccess(messages: messages)),
      );
    } catch (e) {
      emit(GetMessagesViewModelStatesError(
          failure: ServerFailure(e.toString())));
    }
  }
 
}
