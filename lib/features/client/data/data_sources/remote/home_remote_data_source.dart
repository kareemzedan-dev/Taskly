import 'package:either_dart/either.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/client/domain/entities/home/freelancer_entity.dart';
import 'package:taskly/features/client/domain/entities/home/service_response_entity.dart';
import 'package:taskly/domain/entities/user_info_entity/user_info_entity.dart';

abstract class 
HomeRemoteDataSource {
 
 
 Future<Either<Failures,List<ServiceEntity>>> getServices();
 Future<Either<Failures,OrderEntity>> placeOrder(OrderEntity orderEntity);
 Future<Either<Failures,List<FreelancerEntity>>> getAllFreelancerInfo();
 }
 
