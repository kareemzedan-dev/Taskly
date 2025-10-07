import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/conversation_entity.dart';
import '../../../domain/use_cases/get_conversations_use_case/get_conversations_use_case.dart';
import 'get_conversations_states.dart';

@injectable
class GetConversationsViewModel extends Cubit<GetConversationsStates> {
  GetConversationsViewModel(this.getConversationsUseCase)
    : super(GetConversationsInitialStates());
  GetConversationsUseCase getConversationsUseCase;

  Future<Either<Failures, List<ConversationEntity>>> getConversations(
    String userId,
  ) async {
    try {
      emit(GetConversationsLoadingStates());
      var result = await getConversationsUseCase.call(userId);
      result.fold(
        (l) => emit(GetConversationsErrorStates(errorMessage: "Error, try again")),
        (r) => emit(GetConversationsSuccessStates(conversationsList: r)),
      );
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
