import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/freelancer/domain/repos/freelancer_order_repo/freelancer_order_repo.dart';
@injectable
class UpdateOrderStatusUseCase {
  FreelancerOrderRepo freelancerOrderRepo ;

  UpdateOrderStatusUseCase(this.freelancerOrderRepo);

  Future<Either<Failures, void>> call(String orderId , String status) => freelancerOrderRepo.updateOrderStatus(orderId, status);

}