import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/attachments/domain/entities/attachment_entity/attaachments_entity.dart';
 

abstract class AttachmentsRepository {
 
 
  Future<Either<Failures, File>> downloadAttachments(String url, String fileName);
  Future<Either<Failures, List<AttachmentEntity>>> uploadAttachments(List<File> files);
  Future<Either<Failures, void>> deleteAttachment(String attachmentId);
}