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

 
@injectable
class UploadAttachmentsViewModel extends Cubit<UploadAttachmentsViewModelStates> {
  UploadAttachmentsViewModel(this.uploadAttachmentsUseCase)
      : super(UploadAttachmentsViewModelStatesInitial());

  final UploadAttachmentsUseCase uploadAttachmentsUseCase;

  List<File> files = [];
  Set<String> uploadedFileHashes = {};
  Map<File, String> _fileKeys = {};
  int _fileCounter = 0;
  List<AttachmentModel> uploadedAttachments = [];
  
  String _generateFileKey(File file) {
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
  Future<void> pickFilesFromDevice({String? bucketName}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        final List<File> validFiles = [];

        for (final platformFile in result.files) {
          if (platformFile.path == null) continue;

          final file = File(platformFile.path!);
          final fileHash = await generateFileHash(file);

          if (uploadedFileHashes.contains(fileHash)) continue;

          bool alreadyInList = false;
          for (final existingFile in files) {
            final existingHash = await generateFileHash(existingFile);
            if (existingHash == fileHash) {
              alreadyInList = true;
              break;
            }
          }

          if (!alreadyInList) {
            validFiles.add(file);
            _generateFileKey(file);
          }
        }

        if (validFiles.isNotEmpty) {
          files.addAll(validFiles);
          emit(UploadAttachmentsViewModelStatesInitial());

          // رفع الملفات مع تحديد bucketName
          await uploadAttachments(bucketName: bucketName);
        }
      }
    } catch (e) {
      emit(UploadAttachmentsViewModelStatesError(message: e.toString()));
    }
  }
 void removeFileFromQueue(File file) async {
    final fileHash = await generateFileHash(file);

    files.remove(file);

    _fileKeys.remove(file);

    uploadedFileHashes.remove(fileHash);

    uploadedAttachments.removeWhere((e) => e.name == file.path.split('/').last);

    emit(UploadAttachmentsViewModelStatesInitial());
  }


  Future<Either<Failures, List<AttachmentEntity>>> uploadAttachments({String? bucketName}) async {
    
    try {
      emit(UploadAttachmentsViewModelStatesLoading());

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
        emit(UploadAttachmentsViewModelStatesError(
            message: duplicateFiles.isNotEmpty
                ? 'All files have already been uploaded'
                : 'No files to upload'));
        return const Right([]);
      }

      final result = await uploadAttachmentsUseCase.callUploadAttachments(newFiles, bucketName: bucketName);

      result.fold(
            (failure) => emit(UploadAttachmentsViewModelStatesError(message: failure.message)),
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

          emit(UploadAttachmentsViewModelStatesSuccess(attachments: attachments));
        },
      );

      return result;
    } catch (e) {
      final failure = ServerFailure(e.toString());
      emit(UploadAttachmentsViewModelStatesError(message: failure.message));
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
    emit(UploadAttachmentsViewModelStatesInitial());
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
    emit(UploadAttachmentsViewModelStatesInitial());
  }

  void clearAllFiles() {
    files.clear();
    uploadedFileHashes.clear();
    _fileKeys.clear();
    _fileCounter = 0;
    emit(UploadAttachmentsViewModelStatesInitial());
  }
}