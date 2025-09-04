import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/features/client/domain/entities/home/order_entity.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';
import 'package:taskly/features/client/domain/entities/home/user_info_entity.dart';
import 'package:taskly/features/client/domain/repos/home/home_repos.dart';
@injectable
class HomeUseCase {
  HomeRepos homeRepos;
  HomeUseCase(this.homeRepos);

  Future<Either<Failures, UserInfoEntity>> call() => homeRepos.getUserInfo();
  Future<Either<Failures,List<ServiceEntity>>> callServices() => homeRepos.getServices();
  Future<Either<Failures,OrderEntity>> callPlaceOrder(OrderEntity orderEntity) => homeRepos.placeOrder(orderEntity);
  
  
}