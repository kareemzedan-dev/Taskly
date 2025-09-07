import 'package:either_dart/either.dart';
import 'package:taskly/core/helper/failures.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';

abstract class OrdersRemoteDataSource {
  Future<Either<Failures, List<OrderEntity>>> getUserOrdersByUserId(String userId, String role);
}