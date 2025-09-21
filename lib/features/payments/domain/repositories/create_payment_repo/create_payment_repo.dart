
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/failures.dart';
import '../../entities/payment_entity.dart';


abstract class CreatePaymentRepo {
  Future<Either<Failures, PaymentEntity>> createPayment(PaymentEntity paymentEntity) ;
}