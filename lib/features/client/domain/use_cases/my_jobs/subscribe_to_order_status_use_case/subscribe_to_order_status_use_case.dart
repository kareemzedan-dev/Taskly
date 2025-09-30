import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/features/client/domain/repos/my_jobs/my_jobs_repo.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:injectable/injectable.dart';
@injectable
class SubscribeToOrderStatusUseCase {
   final MyJobsRepo myJobsRepo;

  SubscribeToOrderStatusUseCase(this.myJobsRepo);
  
  RealtimeChannel subscribeToOrderStatus({
    required Map<String, String> filters,
    required void Function(OrderEntity order, String action) onChange,
  }) {
    return myJobsRepo.subscribeToOrders(filters, onChange);
  }
}