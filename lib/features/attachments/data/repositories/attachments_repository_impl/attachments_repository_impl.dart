import 'dart:io';

import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';

import 'package:taskly/core/errors/failures.dart';

import '../../../domain/repositories/attachments_repository/attachments_repository.dart';
import '../../data_sources/local/attachments_remote_data_source/attachments_remote_data_source.dart';
@Injectable(as:AttachmentsRepository )
class AttachmentsRepositoryImpl extends AttachmentsRepository {
  final AttachmentsRemoteDataSource remoteDataSource;
  AttachmentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failures, File>> download(  url, String fileName)  {
 return remoteDataSource.downloadAttachments(url, fileName) ;
  }
}