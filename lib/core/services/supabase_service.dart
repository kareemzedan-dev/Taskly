import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
@singleton
class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> sendDataToSupabase({
    required String tableName,
    required Map<String, dynamic> data,
    String? conflictColumn,  
  }) async {
    try {
      final insertedData = await supabase
          .from(tableName)
          .upsert(data, onConflict: conflictColumn)
          .select()
          .single(); 

      print('Data inserted/updated successfully into $tableName: $insertedData');
      return insertedData;  
    } catch (e) {
      print('Exception inserting/updating into $tableName: $e');
      return null;
    }
  }
}
