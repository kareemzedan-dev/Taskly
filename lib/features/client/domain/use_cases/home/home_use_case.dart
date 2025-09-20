
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/profile/domain/entities/user_info_entity/user_info_entity.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';
import 'package:taskly/features/client/domain/repos/home/home_repos.dart';

 

@injectable
class HomeUseCase {
  HomeRepos homeRepos;
  HomeUseCase(this.homeRepos);

  Future<Either<Failures,List<ServiceEntity>>> callServices() => homeRepos.getServices();
  Future<Either<Failures,OrderEntity>> callPlaceOrder(OrderEntity orderEntity) => homeRepos.placeOrder(orderEntity);
 
  Future<Either<Failures, List<UserInfoEntity>>> callGetFreelancer() => homeRepos.getAllFreelancer();
 
 

}