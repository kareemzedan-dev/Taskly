import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/core/utils/network_utils.dart';
import 'package:taskly/features/freelancer/data/data_sources/remote/offer_data_source.dart';
import 'package:taskly/features/freelancer/data/models/offer_dm/offer_dm.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

import '../../../../shared/data/models/order_dm/order_dm.dart';

@Injectable(as: OfferRemoteDataSource)
class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  final SupabaseService supabaseService = SupabaseService();
  RealtimeChannel? _offersChannel;
  @override
  Future<Either<Failures, OfferEntity>> placeOffer(
      OfferEntity offerEntity) async {
    try {
      if (NetworkUtils.hasInternet() == false) {
        return Left(NetworkFailure('No internet connection'));
      }

      final offerModel = OfferModel(
        id: offerEntity.id,
        freelancerId: offerEntity.freelancerId,
        clientId: offerEntity.clientId,
        orderId: offerEntity.orderId,
        offerAmount: offerEntity.offerAmount,
        offerStatus: offerEntity.offerStatus,
        offerDescription: offerEntity.offerDescription,
        offerDeliveryTime: offerEntity.offerDeliveryTime,
        createdAt: offerEntity.createdAt,
        updatedAt: offerEntity.updatedAt,
      );

      final response = await supabaseService.sendDataToSupabase(
        tableName: "offers",
        data: offerModel.toJson(),
      );

      final orderId = offerEntity.orderId;
      final order = await supabaseService.client
          .from('orders')
          .select('offers_count')
          .eq('id', orderId)
          .maybeSingle();

      final currentCount = order?['offers_count'] ?? 0;

      await supabaseService.client
          .from('orders')
          .update({'offers_count': currentCount + 1}).eq('id', orderId);

      var offer = OfferModel.fromJson(response!);
      return Right(offer);
    } catch (e) {
      return Left(ServerFailure('Error while placing offer: $e'));
    }
  }

  @override
  Future<Either<Failures, List<OfferEntity>>> getFreelancerOffers(
      String freelancerId, String status) async {
    try {
      if (NetworkUtils.hasInternet() == false) {
        return Left(NetworkFailure('No internet connection'));
      }

      final query = supabaseService.client
          .from('offers')
          .select()
          .eq('freelancer_id', freelancerId)
          .neq('status', 'withdrawn');

      if (status != 'all') {
        query.eq('status', status);
      }

      final response = await query;

      if (response == null || (response is List && response.isEmpty)) {
        return Right([]);
      }

      final offers = (response as List)
          .map((json) => OfferModel.fromJson(json).toEntity())
          .toList();

      return Right(offers);
    } catch (e) {
      return Left(ServerFailure('Error while fetching freelancer offers: $e'));
    }
  }

  @override
  Future<Either<Failures, OrderEntity>> fetchOrderDetails(
      String orderId) async {
    try {
      if (NetworkUtils.hasInternet() == false) {
        return Left(NetworkFailure('No internet connection'));
      }

      final orderResponse = await supabaseService.client
          .from('orders')
          .select()
          .eq('id', orderId)
          .maybeSingle();

      if (orderResponse == null) {
        return Left(ServerFailure('Order not found'));
      }

      final order = OrderDm.fromJson(orderResponse);
      return Right(order);
    } catch (e) {
      return Left(ServerFailure('Error while fetching order details: $e'));
    }
  }

  @override
  RealtimeChannel subscribeToOffers(
    String freelancerId,
    void Function(OfferEntity offer, String action) onChange,
  ) {
    _offersChannel = supabaseService.client
        .channel('offers:freelancer_id=eq.$freelancerId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'offers',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'freelancer_id',
            value: freelancerId,
          ),
          callback: (payload) {
            final offer = OfferModel.fromJson(payload.newRecord).toEntity();
            onChange(offer, 'INSERT');
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'offers',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'freelancer_id',
            value: freelancerId,
          ),
          callback: (payload) {
            final offer = OfferModel.fromJson(payload.newRecord).toEntity();
            onChange(offer, 'UPDATE');
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'offers',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'freelancer_id',
            value: freelancerId,
          ),
          callback: (payload) {
            final offer = OfferModel.fromJson(payload.oldRecord).toEntity();
            onChange(offer, 'DELETE');
          },
        )
        .subscribe();

    return _offersChannel!;
  }

  @override
  void unsubscribeFromOffers(RealtimeChannel channel) {
    if (_offersChannel != null) {
      supabaseService.client.removeChannel(_offersChannel!);
      _offersChannel = null;
    }
  }
}
