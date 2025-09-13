import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:async/async.dart';
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

  Future<List<Map<String, dynamic>>?> getDataFromSupabase({
    required String tableName,
    Map<String, dynamic>? filters, 
  }) async {
    try {
      var query = supabase.from(tableName).select();

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


Map<String, CancelableOperation<String>> uploadTasks = {};

Future<String> uploadFile(
  File file, {
  Function(int sentBytes, int totalBytes)? onProgress,
}) async {
  final operation = CancelableOperation<String>.fromFuture(_uploadFileInternal(file, onProgress: onProgress));
  uploadTasks[file.path] = operation;

  try {
    final url = await operation.value;
    uploadTasks.remove(file.path);
    return url;
  } catch (e) {
    uploadTasks.remove(file.path);
    rethrow;
  }
}

Future<String> _uploadFileInternal(
  File file, {
  Function(int sentBytes, int totalBytes)? onProgress,
}) async {
  final uuid = Uuid();
  final fileName = '${uuid.v4()}_${file.path.split('/').last}';
  final totalBytes = await file.length();

  if (onProgress != null) {
    const int chunks = 20;
    final chunkSize = totalBytes ~/ chunks;

    for (int i = 1; i <= chunks; i++) {
      await Future.delayed(Duration(milliseconds: 100));
      onProgress(chunkSize * i, totalBytes);
    }
  }

  final response = await Supabase.instance.client.storage
      .from('order-attachments')
      .upload(fileName, file);

  final publicUrl = Supabase.instance.client.storage
      .from('order-attachments')
      .getPublicUrl(fileName);

  return publicUrl;
}

}
