import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/domain/entities/user_info_entity/user_info_entity.dart';
import 'package:taskly/domain/repos/profile/profile_repo.dart';
@injectable
class ProfileUseCase {
  ProfileRepo profileRepo;

  ProfileUseCase(this.profileRepo);
 Future<Either<Failures,UserInfoEntity>> callUserInfo() => profileRepo.getUserInfo();
}