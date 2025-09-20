import 'dart:io';

import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';

import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/attachments/domain/entities/attachment_entity/attaachments_entity.dart';

import '../../../domain/repositories/attachments_repository/attachments_repository.dart';
 import '../../data_sources/remote/attachments_remote_data_source/attachments_remote_data_source.dart';
@Injectable(as:AttachmentsRepository )
class AttachmentsRepositoryImpl extends AttachmentsRepository {
  final AttachmentsRemoteDataSource remoteDataSource;
  AttachmentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failures, File>> downloadAttachments(  url, String fileName)  {
 return remoteDataSource.downloadAttachments(url, fileName) ;
  }

  @override
  Future<Either<Failures, List<AttachmentEntity>>> uploadAttachments(List<File> files) {
 return remoteDataSource.uploadAttachments(files);
  }

  @override
  Future<Either<Failures, void>> deleteAttachment(String attachmentId) {
   return remoteDataSource.deleteAttachment(attachmentId);
  }
}