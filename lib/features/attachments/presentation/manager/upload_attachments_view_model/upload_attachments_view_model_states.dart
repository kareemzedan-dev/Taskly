
 
import 'package:taskly/features/attachments/domain/entities/attachment_entity/attaachments_entity.dart';

// upload_attachments_view_model_states.dart
sealed class UploadAttachmentsViewModelStates {
  const UploadAttachmentsViewModelStates();
}

class UploadAttachmentsViewModelStatesInitial
    extends UploadAttachmentsViewModelStates {}

class UploadAttachmentsViewModelStatesLoading
    extends UploadAttachmentsViewModelStates {}

class UploadAttachmentsViewModelStatesUploading
    extends UploadAttachmentsViewModelStates {
  final double progress; // من 0.0 إلى 1.0
  final String? currentFileName;

  const UploadAttachmentsViewModelStatesUploading(
      this.progress,
      {this.currentFileName}
      );
}

class UploadAttachmentsViewModelStatesSuccess
    extends UploadAttachmentsViewModelStates {
  final List<AttachmentEntity> attachments;

  const UploadAttachmentsViewModelStatesSuccess({required this.attachments});
}

class UploadAttachmentsViewModelStatesError
    extends UploadAttachmentsViewModelStates {
  final String message;

  const UploadAttachmentsViewModelStatesError({required this.message});
}