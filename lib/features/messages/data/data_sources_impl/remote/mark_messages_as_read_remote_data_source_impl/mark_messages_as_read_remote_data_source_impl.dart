

import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/messages/data/data_sources/remote/mark_messages_as_read_remote_data_source/mark_messages_as_read_remote_data_source.dart';
@Injectable(as: MarkMessagesAsReadRemoteDataSource)
class MarkMessagesAsReadRemoteDataSourceImpl extends MarkMessagesAsReadRemoteDataSource{
  final SupabaseService supabaseService;

  MarkMessagesAsReadRemoteDataSourceImpl({required this.supabaseService});

    @override
  Future<Either<Failures, void>> markMessagesAsRead(String orderId) async {
    try {
      await supabase
          .from('messages')
          .update({'is_read': true})
          .eq('order_id', orderId);

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}