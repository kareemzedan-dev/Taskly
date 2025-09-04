import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@singleton
class SupabaseService {
  final supabase = Supabase.instance.client;

  // Insert or Update
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

  // Get Data
  Future<List<Map<String, dynamic>>?> getDataFromSupabase({
    required String tableName,
    Map<String, dynamic>? filters, // optional filters
  }) async {
    try {
      var query = supabase.from(tableName).select();

      // لو عايز تعمل فلترة
      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      final response = await query;

      print('Data fetched successfully from $tableName: $response');
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Exception fetching from $tableName: $e');
      return null;
    }
  }

  Future<String> uploadFile(File file) async {
  final fileName = file.path.split('/').last;
  final response = await Supabase.instance.client.storage
      .from('orders-attachments')
      .upload(fileName, file);

  final publicUrl = Supabase.instance.client.storage
      .from('orders-attachments')
      .getPublicUrl(fileName);

  return publicUrl;
}

}
