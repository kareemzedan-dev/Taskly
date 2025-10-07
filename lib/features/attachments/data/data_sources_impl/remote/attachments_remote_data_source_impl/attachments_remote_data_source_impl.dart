import 'dart:io';
import 'package:dio/dio.dart';
import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/core/services/supabase_service.dart';
import 'package:taskly/features/attachments/domain/entities/attachment_entity/attaachments_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../data_sources/remote/attachments_remote_data_source/attachments_remote_data_source.dart';

 @Injectable(as: AttachmentsRemoteDataSource)
class AttachmentsRemoteDataSourceImpl extends AttachmentsRemoteDataSource {
  final Dio dio;
  final SupabaseClient supabase;
  SupabaseService supabaseService  ;
  final String defaultBucket;

  AttachmentsRemoteDataSourceImpl(
      this.dio,
         this.supabaseService,
      this.supabase, {
        this.defaultBucket = 'order-attachments',
        
      });
  @override
  Future<Either<Failures, File>> downloadAttachments(
      String url,
      String fileName, {
        String? saveDir,
      }) async {
    try {
      final dir = saveDir != null ? Directory(saveDir) : await getApplicationDocumentsDirectory();
      final savePath = "${dir.path}/$fileName";

      await dio.download(url, savePath);

      final file = File(savePath);

      if (!file.existsSync()) {
        return const Left(ServerFailure("File not found after download"));
      }

      return Right(file);
    } catch (e) {
      return Left(ServerFailure("Failed to download file: $e"));
    }
  }


  @override
  Future<Either<Failures, List<AttachmentEntity>>> uploadAttachments(
      List<File> files, {
        String? bucketName,
      }) async {
    try {
      final supabase = supabaseService.supabaseClient;
      const uuid = Uuid();
      final bucket = bucketName ?? defaultBucket;

      List<AttachmentEntity> uploadedAttachments = [];

      for (var file in files) {
    final fileName = file.path.split('/').last;
final uniqueName = "${uuid.v4()}_$fileName";
final fileBytes = await file.readAsBytes();

// رفع الملف
await supabase.storage.from(bucket).uploadBinary(uniqueName, fileBytes);

String safeUrl = supabase.storage.from(bucket).getPublicUrl(Uri.encodeComponent(uniqueName));
safeUrl = safeUrl.endsWith('/') ? safeUrl.substring(0, safeUrl.length - 1) : safeUrl;


 
uploadedAttachments.add(
  AttachmentEntity(
    id: uuid.v4(),
    name: fileName,
    storagePath: uniqueName,
    url: safeUrl,
    size: file.lengthSync(),
    type: _getMimeType(fileName),
  ),
);

      }

      return Right(uploadedAttachments);
    } catch (e) {
      return Left(ServerFailure("Upload failed: ${e.toString()}"));
    }
  }


  String _getMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
  @override
  Future<Either<Failures, void>> deleteAttachment(
      String storagePath, {
        String? bucketName,
      }) async {
    try {
      final bucket = bucketName ?? defaultBucket;

      final removedFiles = await supabase.storage.from(bucket).remove([storagePath]);

      if (removedFiles.isEmpty) {
        return const Left(ServerFailure('File not found or already deleted'));
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
