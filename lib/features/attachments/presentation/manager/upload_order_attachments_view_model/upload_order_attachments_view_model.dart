import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/errors/failures.dart';
import 'package:taskly/features/attachments/data/models/attachments_dm/attachments_dm.dart';
import 'package:taskly/features/attachments/domain/entities/attachment_entity/attaachments_entity.dart';
import 'package:taskly/features/attachments/domain/use_cases/upload_attachments/upload_attachments_use_case.dart';
import 'package:taskly/features/attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model_states.dart';
import 'package:taskly/features/attachments/presentation/manager/upload_order_attachments_view_model/upload_order_attachments_states.dart';


@injectable
class UploadOrderAttachmentsViewModel extends Cubit<UploadOrderAttachmentsViewModelStates> {
  UploadOrderAttachmentsViewModel(this.uploadAttachmentsUseCase)
      : super(UploadOrderAttachmentsViewModelStatesInitial());

  final UploadAttachmentsUseCase uploadAttachmentsUseCase;

  List<File> files = [];
  Set<String> uploadedFileHashes = {};
  final Map<File, String> _fileKeys = {};
  int _fileCounter = 0;
  List<AttachmentModel> uploadedAttachments = [];

  String generateFileKey(File file) {
    if (!_fileKeys.containsKey(file)) {
      _fileKeys[file] = 'file_${_fileCounter++}_${DateTime.now().millisecondsSinceEpoch}';
    }
    return _fileKeys[file]!;
  }

  Future<String> generateFileHash(File file) async {
    final fileName = file.path.split('/').last;
    final fileSize = await file.length();
    return '$fileName-$fileSize';
  }
  Future<void> pickFilesFromDevice({
    String? bucketName,
    bool singleFileMode = false,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false, // ⛔ ملف واحد في كل اختيار
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;

        if (platformFile.path != null) {
          final file = File(platformFile.path!);
          final fileHash = await generateFileHash(file);

          if (!uploadedFileHashes.contains(fileHash)) {
            if (singleFileMode) {
              // ✅ يستبدل القديم بالجديد
              files.clear();
            } else {
              // ✅ يحتفظ بالقديم
              for (final existingFile in files) {
                final existingHash = await generateFileHash(existingFile);
                if (existingHash == fileHash) {
                  return; // الملف مكرر
                }
              }
            }

            files.add(file);
            generateFileKey(file);

            emit(UploadOrderAttachmentsViewModelStatesInitial());

            await uploadAttachments(bucketName: bucketName);
          }
        }
      }
    } catch (e) {
      emit(UploadOrderAttachmentsViewModelStatesError(message: e.toString()));
    }
  }

  void removeFileFromQueue(File file) async {
    final fileHash = await generateFileHash(file);

    files.remove(file);

    _fileKeys.remove(file);

    uploadedFileHashes.remove(fileHash);

    uploadedAttachments.removeWhere((e) => e.name == file.path.split('/').last);

    emit(UploadOrderAttachmentsViewModelStatesInitial());
  }


  Future<Either<Failures, List<AttachmentEntity>>> uploadAttachments({String? bucketName}) async {

    try {
      emit(UploadOrderAttachmentsViewModelStatesLoading());

      final newFiles = <File>[];
      final duplicateFiles = <File>[];

      for (final file in files) {
        final fileHash = await generateFileHash(file);
        if (uploadedFileHashes.contains(fileHash)) {
          duplicateFiles.add(file);
        } else {
          newFiles.add(file);
        }
      }

      if (newFiles.isEmpty) {
        emit(UploadOrderAttachmentsViewModelStatesError(
            message: duplicateFiles.isNotEmpty
                ? 'All files have already been uploaded'
                : 'No files to upload'));
        return const Right([]);
      }

      final result = await uploadAttachmentsUseCase.callUploadAttachments(newFiles, bucketName: bucketName);

      result.fold(
            (failure) => emit(UploadOrderAttachmentsViewModelStatesError(message: failure.message)),
            (attachments) async {
          for (final file in newFiles) {
            final hash = await generateFileHash(file);
            uploadedFileHashes.add(hash);
          }

          uploadedAttachments.addAll(
            attachments.map((e) => AttachmentModel(
              id: e.id,
              name: e.name,
              size: e.size,
              type: e.type,
              url: e.url,
              storagePath: e.storagePath,
            )),
          );

          emit(UploadOrderAttachmentsViewModelStatesSuccess(attachments: attachments));
        },
      );

      return result;
    } catch (e) {
      final failure = ServerFailure(e.toString());
      emit(UploadOrderAttachmentsViewModelStatesError(message: failure.message));
      return Left(failure);
    }
  }
  void removeFile(File file) {
    final fileHash = generateFileHash(file);
    fileHash.then((hash) {
      if (uploadedFileHashes.contains(hash)) {
        uploadedFileHashes.remove(hash);
      }
    });

    files.remove(file);
    _fileKeys.remove(file);
    emit(UploadOrderAttachmentsViewModelStatesInitial());
  }

  Future<void> clearFiles() async {
    final List<File> filesToKeep = [];

    for (final file in files) {
      final fileHash = await generateFileHash(file);
      if (uploadedFileHashes.contains(fileHash)) {
        filesToKeep.add(file);
      }
    }

    files = filesToKeep;
    emit(UploadOrderAttachmentsViewModelStatesInitial());
  }

  void clearAllFiles() {
    files.clear();
    uploadedFileHashes.clear();
    _fileKeys.clear();
    _fileCounter = 0;
    emit(UploadOrderAttachmentsViewModelStatesInitial());
  }
}