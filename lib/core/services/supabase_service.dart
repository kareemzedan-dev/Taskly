import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:async/async.dart';

typedef RealtimeCallback = void Function(Map<String, dynamic> record, String action);

@singleton
class SupabaseService {
  final supabase = Supabase.instance.client;
  final Map<String, RealtimeChannel> _channels = {};
  final SupabaseClient _client = Supabase.instance.client;

  SupabaseClient get client => _client;
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
  Future<Map<String, dynamic>?> updateDataInSupabase({
    required String tableName,
    required Map<String, dynamic> data,
    required Map<String, dynamic> match,
  }) async {
    try {
      var query = supabase.from(tableName).update(data);


      match.forEach((key, value) {
        query = query.eq(key, value);
      });

      final updatedData = await query.select().maybeSingle();

      print('Data updated successfully in $tableName: $updatedData');
      return updatedData;
    } catch (e) {
      print('Exception updating in $tableName: $e');
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
  RealtimeChannel subscribe({
    required String table,
    required RealtimeCallback onChange,
    List<PostgresChangeEvent> events = const [
      PostgresChangeEvent.insert,
      PostgresChangeEvent.update,
      PostgresChangeEvent.delete,
    ],
    Map<String, dynamic>? filters,
  }) {
    final channelName = 'public:$table';


    if (_channels.containsKey(channelName)) {
      unsubscribe(table: table);
    }

    final channel = supabase.channel(channelName);

    for (var event in events) {
      channel.onPostgresChanges(
        event: event,
        schema: 'public',
        table: table,
        filter: filters != null
            ? PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: filters.keys.first,
          value: filters.values.first,
        )
            : null,
        callback: (payload) {
          final record = event == PostgresChangeEvent.delete
              ? payload.oldRecord
              : payload.newRecord;
          onChange(record, event.name);
        },
      );
    }

    channel.subscribe();
    _channels[channelName] = channel;
    return channel;
  }


  void unsubscribe({required String table}) {
    final channelName = 'public:$table';
    if (_channels.containsKey(channelName)) {
      supabase.removeChannel(_channels[channelName]!);
      _channels.remove(channelName);
    }
  }

  void unsubscribeAll() {
    for (var channel in _channels.values) {
      supabase.removeChannel(channel);
    }
    _channels.clear();
  }
}
