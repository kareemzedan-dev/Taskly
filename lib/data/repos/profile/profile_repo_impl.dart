import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/data/data_sources/remote/profile_remote_data_source.dart';
import 'package:taskly/domain/entities/user_info_entity/user_info_entity.dart';
import 'package:taskly/domain/repos/profile/profile_repo.dart';
@Injectable(as: ProfileRepo)
class ProfileRepoImpl extends ProfileRepo{
  ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepoImpl(this.profileRemoteDataSource);
  @override
  Future<Either<Failures, UserInfoEntity>> getUserInfo() {
    return profileRemoteDataSource.getUserInfo();

 
  }

}