import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:taskly/features/attachments/domain/entities/attachment_entity/attaachments_entity.dart';

import '../../../../../../core/errors/failures.dart';

abstract class AttachmentsRemoteDataSource {
  Future<Either<Failures, File>> downloadAttachments(String url, String fileName);
   Future <Either<Failures,List<AttachmentEntity>>> uploadAttachments(List<File> files);

 Future<Either<Failures, void>> deleteAttachment(String attachmentId);
}