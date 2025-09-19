import 'dart:io';
import 'package:dio/dio.dart';
import 'package:either_dart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskly/core/errors/failures.dart';

import '../../../data_sources/local/attachments_remote_data_source/attachments_remote_data_source.dart';
@Injectable(as: AttachmentsRemoteDataSource)
class AttachmentsRemoteDataSourceImpl extends AttachmentsRemoteDataSource {
  final Dio dio;

  AttachmentsRemoteDataSourceImpl(this.dio);

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
}
