
import '../../../../../../../../attachments/domain/entities/attachment_entity/attaachments_entity.dart';

class UploadAttachmentsViewModelStates {}
class UploadAttachmentsViewModelStatesInitial extends UploadAttachmentsViewModelStates {}
class UploadAttachmentsViewModelStatesLoading extends UploadAttachmentsViewModelStates {}
class UploadAttachmentsViewModelStatesSuccess extends UploadAttachmentsViewModelStates {
  final List<AttachmentEntity> attachments;
  UploadAttachmentsViewModelStatesSuccess({required this.attachments});
}
class UploadAttachmentsViewModelStatesError extends UploadAttachmentsViewModelStates {
  final String message;
  UploadAttachmentsViewModelStatesError({required this.message});
}class UploadAttachmentsViewModelStatesDuplicateWarning extends UploadAttachmentsViewModelStates {


}