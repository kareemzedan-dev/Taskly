import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../features/shared/domain/entities/order_entity/order_entity.dart';
import '../../../../welcome/presentation/cubit/welcome_states.dart';
import '../../repositories/messages_repos/messages_repos.dart';

@injectable
class GetAcceptedOrderMessagesUseCase {
  final MessagesRepos repository;

  GetAcceptedOrderMessagesUseCase(this.repository);

  Future<Either<Failures, List<OrderEntity>>> call(String userId,{UserRole? role}) {
    return repository.getAcceptedOrderMessages(userId, role: role);
  }
}
