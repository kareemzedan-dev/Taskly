import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import '../../../../../../../core/utils/network_utils.dart';
import '../../../../data_sources/remote/earings_remote_data_source/add_earning_remote_data_source/add_earning_remote_data_source.dart';
@Injectable(as:  AddEarningRemoteDataSource)
class AddEarningRemoteDataSourceImpl implements AddEarningRemoteDataSource {
  final SupabaseService supabaseService;

  AddEarningRemoteDataSourceImpl({required this.supabaseService});

  @override
  Future<Either<Failures, void>> addEarning({
    required String freelancerId,
    required double amount,
  }) async {
    try {
      if(!await NetworkUtils.hasInternet()){
        return Left(Failures('No internet connection'));
      }
      final freelancerData = await supabaseService.supabaseClient
          .from('freelancers')
          .select('freelancer_balance')
          .eq('id', freelancerId)
          .single();

      final currentBalance = (freelancerData['freelancer_balance'] ?? 0).toDouble();

      final newBalance = currentBalance + amount;
      await supabaseService.supabaseClient
          .from('freelancers')
          .update({'freelancer_balance': newBalance})
          .eq('id', freelancerId);

      final userData = await supabaseService.supabaseClient
          .from('users')
          .select('total_earnings')
          .eq('id', freelancerId)
          .single();

      final currentTotalEarnings = (userData['total_earnings'] ?? 0).toDouble();

      final newTotalEarnings = currentTotalEarnings + amount;

      await supabaseService.supabaseClient
          .from('users')
          .update({'total_earnings': newTotalEarnings})
          .eq('id', freelancerId);

      return const Right(null);
    } catch (e) {
      return Left(Failures(  e.toString()));
    }
  }
}
