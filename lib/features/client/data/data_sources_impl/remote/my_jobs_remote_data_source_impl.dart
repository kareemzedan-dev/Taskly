import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/core/utils/network_utils.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/client/data/data_sources/remote/my_jobs_remote_data_source.dart';
import 'package:taskly/features/freelancer/data/models/offer_dm/offer_dm.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

import '../../../../shared/data/models/order_dm/order_dm.dart';
@Injectable(as:MyJobsRemoteDataSource )
class MyJobsRemoteDataSourceImpl extends MyJobsRemoteDataSource {
  final SupabaseService supabaseService = SupabaseService();

  @override
  Future<Either<Failures, List<OfferEntity>>> getOffers(String orderId) async {
    try {
    
      if (!await NetworkUtils.hasInternet()) {
        return Left(NetworkFailure(StringsManager.noInternetConnection));
      }

      // Fetch offers
      final response = await supabaseService.client
          .from('offers')
          .select()
          .eq('order_id', orderId)
          .eq('status', 'pending');


      if (response == null || response.isEmpty) {
        return Right([]);
      }

      final offers = (response as List)
          .map((json) => OfferModel.fromJson(json).toEntity())
          .toList();

      return Right(offers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  RealtimeChannel subscribeToOrderOffersCount({
    required String orderId,
    required void Function(int offersCount) onChange,
  }) {
    return supabaseService.subscribe(
      table: 'orders',
      filters: {"id": orderId},
      onChange: (record, action) {
        final count = record['offers_count'] as int? ?? 0;
        onChange(count);
      },
    );
  }
  @override
  Future<Either<Failures, OfferEntity>> updateOfferStatus(
      String offerId,
      String newStatus,
      ) async {
    try {
      // check internet
      if (!await NetworkUtils.hasInternet()) {
        return Left(NetworkFailure(StringsManager.noInternetConnection));
      }


      final response = await supabaseService.updateDataInSupabase(
        tableName: 'offers',
        data: {"status": newStatus},
        match: {"id": offerId},
      );

      if (response != null) {

        final updatedOffer = OfferModel.fromJson(response).toEntity();
        return Right(updatedOffer);
      } else {
        return Left(ServerFailure("Failed to update offer status"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failures, OrderEntity>> acceptOfferAndRejectOthers(
      String orderId, String offerId) async {
    try {
      if (!await NetworkUtils.hasInternet()) {
        return Left(NetworkFailure(StringsManager.noInternetConnection));
      }

      final offerResponse = await supabaseService.client
          .from('offers')
          .select()
          .eq('id', offerId)
          .single();

      if (offerResponse == null) {
        return Left(ServerFailure("Failed to fetch the selected offer"));
      }

      final acceptedOffer = OfferModel.fromJson(offerResponse); // assuming OfferEntity فيه price

      final acceptResponse = await supabaseService.updateDataInSupabase(
        tableName: 'offers',
        data: {"status": "accepted"},
        match: {"id": offerId},
      );

      if (acceptResponse == null) {
        return Left(ServerFailure("Failed to accept the offer"));
      }

      final updateBudget = await supabaseService.updateDataInSupabase(
        tableName: 'orders',
        data: {
          "status": "Accepted",
          "budget": acceptedOffer.offerAmount,
        },
        match: {"id": orderId},
      );

      final rejectResponse = await supabaseService.client
          .from('offers')
          .update({'status': 'rejected'})
          .eq('order_id', orderId)
          .neq('id', offerId)
          .select();

      if (rejectResponse == null) {
        return Left(ServerFailure("Failed to reject other offers"));
      }

      // 5️⃣ جلب الـ order بعد التحديث
      final orderResponse = await supabaseService.client
          .from('orders')
          .select()
          .eq('id', orderId)
          .single();

      if (orderResponse == null) {
        return Left(ServerFailure("Failed to fetch updated order"));
      }

      final updatedOrder = OrderDm.fromJson(orderResponse);

      return Right(updatedOrder);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}
