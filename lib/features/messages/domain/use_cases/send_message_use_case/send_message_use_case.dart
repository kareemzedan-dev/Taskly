import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../features/messages/domain/entities/message_entity.dart';
import '../../repositories/messages_repos/messages_repos.dart';

@lazySingleton
class SendMessageUseCase {
  final MessagesRepos repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failures, MessageEntity>> call(String orderId, MessageEntity message) {
    return repository.sendMessage(orderId, message);
  }

}
