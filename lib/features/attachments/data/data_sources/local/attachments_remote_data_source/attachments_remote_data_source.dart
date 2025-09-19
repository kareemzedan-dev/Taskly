import 'dart:io';

import 'package:either_dart/either.dart';

import '../../../../../../core/errors/failures.dart';

abstract class AttachmentsRemoteDataSource {
  Future<Either<Failures, File>> downloadAttachments(String url, String fileName);
}