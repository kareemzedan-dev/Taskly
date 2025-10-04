import 'package:either_dart/either.dart';

import '../../../../../core/errors/failures.dart';
import '../../entities/user_info_entity/user_info_entity.dart';

abstract class UpdateUserProfileRepo {
  Future<Either<Failures,void>> updateUserInfo( String userId,   String fullName, String email, String phoneNumber, String profileImage) ;


}