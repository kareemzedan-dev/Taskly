
import 'package:either_dart/either.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../models/bank_accounts_model/bank_accounts_model.dart';

abstract class GetBankAccountsRemoteDataSource {
  Future<Either<Failures, List<BankAccountsModel>>> getBankAccountsFromRemote();
}