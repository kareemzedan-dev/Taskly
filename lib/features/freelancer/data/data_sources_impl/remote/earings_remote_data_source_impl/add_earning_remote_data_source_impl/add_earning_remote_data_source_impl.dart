import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import '../../../../../../../core/utils/network_utils.dart';
import '../../../../data_sources/remote/earings_remote_data_source/add_earning_remote_data_source/add_earning_remote_data_source.dart';

@Injectable(as: AddEarningRemoteDataSource)
class AddEarningRemoteDataSourceImpl implements AddEarningRemoteDataSource {
  final SupabaseService supabaseService;

  AddEarningRemoteDataSourceImpl({required this.supabaseService});

  @override
  Future<Either<Failures, void>> addEarning({
    required String freelancerId,
    required String clientId,
    required double amount,
  }) async {
    try {
      if (!await NetworkUtils.hasInternet()) {
        return Left(Failures('No internet connection'));
      }

      // تحديث بيانات الفريلانسر
      final freelancerData = await supabaseService.supabaseClient
          .from('freelancers')
          .select('freelancer_balance, total_orders, completed_orders')
          .eq('id', freelancerId)
          .single();

      final currentBalance = (freelancerData['freelancer_balance'] ?? 0).toDouble();
      final currentTotalOrders = (freelancerData['total_orders'] ?? 0) as int;
      final currentCompletedOrders = (freelancerData['completed_orders'] ?? 0) as int;

      await supabaseService.supabaseClient
          .from('freelancers')
          .update({
        'freelancer_balance': currentBalance + amount,
        'total_orders': currentTotalOrders + 1,
      })
          .eq('id', freelancerId);

      // تحديث بيانات العميل
      final clientData = await supabaseService.supabaseClient
          .from('users')
          .select('total_orders, completed_orders, total_earnings')
          .eq('id', clientId)
          .single();

      final clientTotalOrders = (clientData['total_orders'] ?? 0) as int;
      final clientTotalEarnings = (clientData['total_earnings'] ?? 0).toDouble();

      await supabaseService.supabaseClient
          .from('users')
          .update({
        'total_orders': clientTotalOrders + 1,
        'total_earnings': clientTotalEarnings + amount,
      })
          .eq('id', clientId);

      return const Right(null);
    } catch (e) {
      return Left(Failures(e.toString()));
    }
  }
}
