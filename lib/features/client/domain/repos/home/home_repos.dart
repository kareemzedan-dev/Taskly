import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';
import 'package:taskly/features/client/domain/entities/home/user_info_entity.dart';

abstract class HomeRepos {
  Future<Either<Failures,UserInfoEntity>> getUserInfo();
  Future<Either<Failures,List<ServiceEntity>>> getServices();
}