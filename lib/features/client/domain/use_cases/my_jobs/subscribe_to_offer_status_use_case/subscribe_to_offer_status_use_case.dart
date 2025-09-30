import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/features/client/domain/repos/my_jobs/my_jobs_repo.dart';
import 'package:injectable/injectable.dart';
@injectable
class SubscribeToOfferStatusUseCase {
  final MyJobsRepo myJobsRepo;
  SubscribeToOfferStatusUseCase(this.myJobsRepo);
  RealtimeChannel subscribeToOffers({
    required String orderId,
    required void Function(int offersCount) onChange,
  }) {
    return myJobsRepo.subscribeToOffers(orderId: orderId, onChange: onChange);
  }
}
