import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../repos/freelancer_order_repo/freelancer_order_repo.dart';
@injectable
class FetchPrivateOrdersUseCase {
  final FreelancerOrderRepo repo;
  FetchPrivateOrdersUseCase(this.repo);
  Future<Either<Failures, List<OrderEntity>>> call(String freelancerId) => repo.fetchPrivateOrders(freelancerId);

  RealtimeChannel subscribeRealtime(String freelancerId,void Function(OrderEntity, String) onChange) => repo.subscribeToPrivateOrders(freelancerId, onChange);
}