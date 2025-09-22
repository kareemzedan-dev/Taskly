import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../features/shared/domain/entities/order_entity/order_entity.dart';
import '../../repositories/messages_repos/messages_repos.dart';

@lazySingleton
class GetAcceptedOrderMessagesUseCase {
  final MessagesRepos repository;

  GetAcceptedOrderMessagesUseCase(this.repository);

  Future<Either<Failures, List<OrderEntity>>> call(String userId) {
    return repository.getAcceptedOrderMessages(userId);
  }
}
