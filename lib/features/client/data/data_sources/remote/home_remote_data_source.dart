import 'package:either_dart/either.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/features/client/domain/entities/home/user_info_entity.dart';

abstract class 
HomeRemoteDataSource {
  Future<Either<Failures,UserInfoEntity>> getUserInfo();
 }
