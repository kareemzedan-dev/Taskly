import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../repos/my_jobs/my_jobs_repo.dart';

@injectable
class ClientOrderUseCase {
  final MyJobsRepo myJobsRepo;
  ClientOrderUseCase(this.myJobsRepo);

  RealtimeChannel subscribeToOrders(Map<String, String> filters,
      void Function(OrderEntity order, String action) onChange){
  return    myJobsRepo.subscribeToOrders(filters, onChange);
  }

}