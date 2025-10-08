import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/core/utils/network_utils.dart';
import 'package:taskly/features/reviews/domain/entities/reviews_entity/reviews_entity.dart';
import '../../../data_sources/remote/submit_rating_remote_data_source/submit_rating_remote_data_source.dart';

@Injectable(as: SubmitRatingRemoteDataSource)
class SubmitRatingRemoteDataSourceImpl implements SubmitRatingRemoteDataSource {
  final SupabaseService supabaseService;

  SubmitRatingRemoteDataSourceImpl(this.supabaseService);

  @override
  Future<Either<Failures, void>> submitRating({required ReviewsEntity reviews}) async {
    try {
      print('SubmitRatingRemoteDataSource: Starting rating submission for order ${reviews.orderId}');

      if (!await NetworkUtils.hasInternet()) {
        print('SubmitRatingRemoteDataSource: No internet connection');
        return Left(NetworkFailure("No Internet Connection"));
      }

      // 🔍 تحقق هل فيه تقييم سابق لنفس الـ order من نفس الشخص ونفس الـ role
      print('SubmitRatingRemoteDataSource: Checking for existing review...');
      final existing = await supabaseService.supabaseClient
          .from('reviews')
          .select()
          .eq('order_id', reviews.orderId)
          .eq('role', reviews.role)  // يتحقق من نفس الدور
          .eq(
        reviews.role == 'client' ? 'client_id' : 'freelancer_id',
        reviews.role == 'client' ? reviews.clientId : reviews.freelancerId,
      )
          .maybeSingle();


      if (existing != null) {
        print('SubmitRatingRemoteDataSource: Existing review found -> $existing');
        return Left(ServerFailure('لقد قمت بتقييم هذا الطلب من قبل.'));
      }

      // ✨ مفيش تقييم سابق، نضيف الجديد
      print('SubmitRatingRemoteDataSource: Creating review data...');
      final reviewData = _createReviewData(reviews);

      print('SubmitRatingRemoteDataSource: Inserting into Supabase - $reviewData');
      final response = await supabaseService.supabaseClient
          .from('reviews')
          .insert(reviewData);

      print('SubmitRatingRemoteDataSource: Insert successful - $response');
      return const Right(null);

    } catch (e) {
      print('SubmitRatingRemoteDataSource Error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  Map<String, dynamic> _createReviewData(ReviewsEntity reviews) {
    final data = <String, dynamic>{
      'id': reviews.id,
      'order_id': reviews.orderId,
      'rating': _convertRatingToInt(reviews.rating),
      'comment': reviews.comment.isNotEmpty ? reviews.comment : '',
      'role': reviews.role,
      'created_at': reviews.createdAt.toIso8601String(),
    };

    if (reviews.freelancerId != null && reviews.freelancerId!.isNotEmpty) {
      data['freelancer_id'] = reviews.freelancerId;
    }

    if (reviews.clientId != null && reviews.clientId!.isNotEmpty) {
      data['client_id'] = reviews.clientId;
    }

    return data;
  }

  int _convertRatingToInt(String rating) {
    try {
      final doubleValue = double.parse(rating);
      final intValue = doubleValue.round();
      if (intValue < 1) return 1;
      if (intValue > 5) return 5;
      return intValue;
    } catch (e) {
      print('Error converting rating "$rating" to int, using default value 5');
      return 5;
    }
  }
}
