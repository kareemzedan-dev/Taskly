import 'dart:io';

import 'package:either_dart/either.dart';

import '../../../../../core/errors/failures.dart';

abstract class AttachmentsRepository {
  Future<Either<Failures, File>> download(String url, String fileName);

}