import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../../repositories/messages_repos/messages_repos.dart';

@lazySingleton
class MarkMessagesAsReadUseCase {
  final MessagesRepos repository;

  MarkMessagesAsReadUseCase(this.repository);

  Future<Either<Failures, void>> call(String orderId) {
    return repository.markMessagesAsRead(orderId);
  }
}
