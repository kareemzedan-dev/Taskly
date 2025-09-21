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
  RealtimeChannel? _ordersChannel;
   final SupabaseClient _supabase = Supabase.instance.client;
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

      // 1) هات العرض المطلوب
      final offerResponse = await supabaseService.client
          .from('offers')
          .select()
          .eq('id', offerId)
          .maybeSingle();

      if (offerResponse == null) {
        return Left(ServerFailure("Offer not found"));
      }

      final acceptedOffer = OfferModel.fromJson(offerResponse);

      // 2) حدّث العرض المختار لقبول
      final acceptResponse = await supabaseService.client
          .from('offers')
          .update({"status": "accepted"})
          .eq('id', offerId)
          .select()
          .maybeSingle();

      if (acceptResponse == null) {
        return Left(ServerFailure("Failed to accept the offer"));
      }

      // 3) حدّث الطلب بالـ status + budget
      final updateOrderResponse = await supabaseService.client
          .from('orders')
          .update({
        "status": "Accepted",
        "budget": acceptedOffer.offerAmount,
      })
          .eq('id', orderId)
          .select()
          .maybeSingle();

      if (updateOrderResponse == null) {
        return Left(ServerFailure("Failed to update order"));
      }

      // 4) ارفض باقي العروض
      await supabaseService.client
          .from('offers')
          .update({'status': 'rejected'})
          .eq('order_id', orderId)
          .neq('id', offerId);


      final updatedOrder = OrderDm.fromJson(updateOrderResponse).toEntity();
      return Right(updatedOrder);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  RealtimeChannel subscribeToOrders(
      Map<String, dynamic>? filters,
      void Function(OrderEntity order, String action) onChange,

      ) {
    _ordersChannel = supabaseService.subscribe(
      table: 'orders',
      filters: filters ?? {},
      onChange: (record, action) {
        final order = OrderDm.fromJson(record);
        onChange(order, action);
      },
    );

    return _ordersChannel!;
  }

  void unsubscribeFromOrders() {
    supabaseService.unsubscribe(table: 'orders');
    _ordersChannel = null;
  }

}
