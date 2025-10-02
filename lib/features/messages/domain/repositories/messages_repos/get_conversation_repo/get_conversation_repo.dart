
import 'package:either_dart/either.dart';
import 'package:taskly/features/profile/domain/entities/user_info_entity/user_info_entity.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../entities/conversation_entity.dart';

abstract class GetConversationRepo {
  Future<Either<Failures ,List<ConversationEntity >>> getConversations(String userId);
}