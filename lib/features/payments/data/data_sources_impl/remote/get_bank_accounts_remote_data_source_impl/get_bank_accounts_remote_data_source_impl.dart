import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/services/supabase_service.dart';
import '../../../data_sources/remote/get_bank_accounts_remote_data_source/get_bank_accounts_remote_data_source.dart';
import '../../../models/bank_accounts_model/bank_accounts_model.dart';

@Injectable(as: GetBankAccountsRemoteDataSource)
class GetBankAccountsRemoteDataSourceImpl
    implements GetBankAccountsRemoteDataSource {
  final SupabaseService service;

  GetBankAccountsRemoteDataSourceImpl(this.service);

  @override
  Future<Either<Failures, List<BankAccountsModel>>>
      getBankAccountsFromRemote() async {
    try {
      final List<Map<String, dynamic>> response =
          await service.getAll(table: 'bank_accounts');

      final accounts =
          response.map((json) => BankAccountsModel.fromJson(json)).toList();

      return Right(accounts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
