import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';

import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/payments/data/data_sources/remote/create_payment_remote_data_source.dart';

import 'package:taskly/features/payments/domain/entities/payment_entity.dart';

import '../../../domain/repositories/create_payment_repo/create_payment_repo.dart';
@Injectable(as:CreatePaymentRepo )
class CreatePaymentRepoImpl extends CreatePaymentRepo {
  CreatePaymentRemoteDataSource createPaymentRemoteDataSource;
  CreatePaymentRepoImpl(this.createPaymentRemoteDataSource);
  @override
  Future<Either<Failures, PaymentEntity>> createPayment(PaymentEntity paymentEntity) {
 return createPaymentRemoteDataSource.createPayment(paymentEntity);
  }

}