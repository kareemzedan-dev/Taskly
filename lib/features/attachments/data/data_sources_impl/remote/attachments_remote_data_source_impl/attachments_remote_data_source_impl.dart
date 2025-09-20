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
  SupabaseService supabaseService = SupabaseService();
  AttachmentsRemoteDataSourceImpl(this.dio, this.supabase);

  @override
  Future<Either<Failures, File>> downloadAttachments(String url, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = "${dir.path}/$fileName";

      await dio.download(url, savePath);

      final file = File(savePath);

      if (!file.existsSync()) {
        return Left(ServerFailure("File not found after download"));
      }

      return Right(file);
    } catch (e) {
      return Left(ServerFailure("Failed to download file: $e"));
    }
  }
  
  @override
 
  Future<Either<Failures, List<AttachmentEntity>>> uploadAttachments(List<File> files) async {
    try {
      final supabase = supabaseService.supabase;
      final uuid = const Uuid();
      List<AttachmentEntity> uploadedAttachments = [];

      for (var file in files) {
        final fileName = file.path.split('/').last;
        final uniqueName = "${uuid.v4()}_$fileName";
        final fileBytes = await file.readAsBytes();

        await supabase.storage
            .from('order-attachments')
            .uploadBinary(uniqueName, fileBytes);

        final url = supabase.storage
            .from('order-attachments')
            .getPublicUrl(uniqueName);
        uploadedAttachments.add(
          AttachmentEntity(
            id: uuid.v4(),           
            name: fileName,
            storagePath: uniqueName,  
            url: url,
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
  Future<Either<Failures, void>> deleteAttachment(String storagePath) async {
    try {
      final removedFiles = await supabase.storage
          .from('order-attachments')
          .remove([storagePath]);

      print('Supabase remove response: $removedFiles');

      if (removedFiles.isEmpty) {
        print('Warning: file not found or already deleted');
        return Left(ServerFailure('File not found or already deleted'));
      }

      print('File deleted successfully');
      return const Right(null);
    } catch (e, st) {
      print('Error deleting file: $e');
      print('Stack trace: $st');
      return Left(ServerFailure(e.toString()));
    }
  }


}
