
import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';

import 'package:taskly/core/errors/failures.dart';

import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

import '../../../../../../../core/services/supabase_service.dart';
import '../../../../../../../core/utils/network_utils.dart';
import '../../../../../../shared/data/models/order_dm/order_dm.dart';
import '../../../../data_sources/remote/freelancer_orders/fetch_public_orders_remote_data_source/fetch_public_orders_remote_data_source.dart';
@Injectable(as: FetchPublicOrdersRemoteDataSource)
class FetchPublicOrdersRemoteDataSourceImpl implements FetchPublicOrdersRemoteDataSource{
  final SupabaseService _supabaseService;
  FetchPublicOrdersRemoteDataSourceImpl(this._supabaseService);


  @override
  Future<Either<Failures, List<OrderEntity>>> fetchPublicOrders(String freelancerId) async {
    try {
      if (NetworkUtils.hasInternet() == false) {
        return const Left(NetworkFailure('No internet connection'));
      }

      // جلب الأوردرات اللي الفريلانسر قدم عليها
      final offersResponse = await _supabaseService.supabaseClient
          .from('offers')
          .select('order_id')
          .eq('freelancer_id', freelancerId);

      final offeredOrderIds = ((offersResponse as List).isEmpty)
          ? <String>[]
          : (offersResponse as List).map((e) => e['order_id'] as String).toList();

      // بناء الاستعلام
      var query = _supabaseService.supabaseClient
          .from('orders')
          .select('*')
          .eq('status', 'Pending') // بالظبط زي ما موجودة في قاعدة البيانات
          .eq('service_type', 'public');

      // استبعاد الأوردرات اللي قدم عليها الفريلانسر لو فيه فعلاً
      if (offeredOrderIds.isNotEmpty) {
        query = query.not('id', 'in', offeredOrderIds);
      }

      final response = await query;

      if ((response as List).isEmpty) return const Right([]);

      final orders = response
          .map((json) => OrderDm.fromJson(json).toEntity())
          .toList(); // مش هنعمل فلترة إضافية هنا

      return Right(orders);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch pending orders: $e'));
    }
  }
}