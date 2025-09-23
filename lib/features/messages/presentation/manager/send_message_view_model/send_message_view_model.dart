import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/messages/presentation/manager/send_message_view_model/send_message_view_model_states.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/use_cases/send_message_use_case/send_message_use_case.dart';
@injectable
class SendMessageViewModel extends Cubit<SendMessageViewModelStates> {
  final SendMessageUseCase sendMessageUseCase;

  SendMessageViewModel(this.sendMessageUseCase) : super(SendMessageViewModelStatesInitial());

  Future<void> sendMessage(String orderId, MessageEntity message) async {
    try {
      emit(SendMessageViewModelStatesLoading());
      print("Sending message: ${message.toJson()}"); // لو عندك toJson()

      final result = await sendMessageUseCase.call(orderId, message);

      result.fold(
            (failure) => emit(SendMessageViewModelStatesError(failure: failure)),
            (message) => emit(SendMessageViewModelStatesSuccess(message: message)),
      );
    } catch (e) {
      emit(SendMessageViewModelStatesError(failure: ServerFailure(e.toString())));
    }
  }
}
