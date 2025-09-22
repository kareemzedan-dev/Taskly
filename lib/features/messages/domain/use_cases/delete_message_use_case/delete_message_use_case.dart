import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../../repositories/messages_repos/messages_repos.dart';

@lazySingleton
class DeleteMessageUseCase {
  final MessagesRepos repository;

  DeleteMessageUseCase(this.repository);

  Future<Either<Failures, void>> call(String messageId) {
    return repository.deleteMessage(messageId);
  }
}
