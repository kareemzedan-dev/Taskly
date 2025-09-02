import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/features/client/data/data_sources/remote/home_remote_data_source.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';
import 'package:taskly/features/client/domain/entities/home/user_info_entity.dart';
import 'package:taskly/features/client/domain/repos/home/home_repos.dart';

@Injectable(as: HomeRepos)
class HomeRepoImpl extends HomeRepos {
  HomeRemoteDataSource homeremoteDataSource;

  HomeRepoImpl({required this.homeremoteDataSource});

  Future<Either<Failures, UserInfoEntity>> getUserInfo() =>
      homeremoteDataSource.getUserInfo();

  @override
  Future<Either<Failures, List<ServiceEntity>>> getServices() {
    return homeremoteDataSource.getServices();
  }
}
