import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/freelancer/domain/repos/freelancer_order_repo/freelancer_order_repo.dart';
@injectable
class WithdrawOfferUseCase {
    FreelancerOrderRepo freelancerOrderRepo ;

    WithdrawOfferUseCase(this.freelancerOrderRepo);

    Future<Either<Failures, void>> withdrawOffer(String offerId, String orderId) => freelancerOrderRepo.withdrawOffer( offerId,orderId);
}