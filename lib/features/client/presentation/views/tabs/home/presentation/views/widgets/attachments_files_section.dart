import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/upload_attachments_view_model/upload_attachments_view_model_states.dart';

import '../../../../../../../../../core/components/dismissible_error_card.dart';
import '../../cubit/upload_attachments_view_model/upload_attachments_view_model.dart';




class AttachmentsFilesSection extends StatelessWidget {
  final UploadAttachmentsViewModel uploadAttachmentsViewModel;
  final VoidCallback? onTap;
  final VoidCallback? onClearAll;

  AttachmentsFilesSection({
    super.key,
    required this.uploadAttachmentsViewModel,
    this.onTap,
    this.onClearAll,
  });


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadAttachmentsViewModel, UploadAttachmentsViewModelStates>(
      bloc: uploadAttachmentsViewModel,
      listener: (context, state) {
        if (state is UploadAttachmentsViewModelStatesLoading) {
          showTemporaryMessage(context, "Uploading...", MessageType.success);
        } else if (state is UploadAttachmentsViewModelStatesError) {
          showTemporaryMessage(context, state.message, MessageType.error);
        } else if (state is UploadAttachmentsViewModelStatesSuccess) {
          showTemporaryMessage(context, "Uploaded Successfully ✅", MessageType.success);
        }
      },
      builder: (context, state) {
        final files = uploadAttachmentsViewModel.files;
        final uploadedHashes = uploadAttachmentsViewModel.uploadedFileHashes;

        return Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: () async {
                    await uploadAttachmentsViewModel.pickFilesFromDevice();
                  },
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Center(
                        child: Text(
                          uploadAttachmentsViewModel.uploadedFileHashes.isEmpty
                              ? "No files uploaded yet"
                              : "${uploadAttachmentsViewModel.uploadedFileHashes.length} files uploaded",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear_all, color: Colors.red),
                  onPressed: onClearAll ?? () {
                    uploadAttachmentsViewModel.clearFiles();
                  },
                  tooltip: 'Clear unuploaded files',
                ),
              ],
            ),
            SizedBox(height: 10.h),

            ...files.map((file) {
              final uniqueKey = Key('${file.path}_${file.lengthSync()}');

              return FutureBuilder<String>(
                  key: uniqueKey,
                  future: uploadAttachmentsViewModel.generateFileHash(file),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                file.path.split('/').last,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    final fileHash = snapshot.data;
                    final isUploaded = fileHash != null && uploadedHashes.contains(fileHash);

                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isUploaded ? Colors.green : Colors.grey.shade300
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        color: isUploaded ? Colors.green.withOpacity(0.1) : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              file.path.split('/').last,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isUploaded ? Colors.green : null,
                                fontWeight: isUploaded ? FontWeight.bold : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUploaded)
                            const Icon(Icons.check_circle, color: Colors.green, size: 20)
                          else if (state is UploadAttachmentsViewModelStatesLoading)
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            const Icon(Icons.pending, color: Colors.orange, size: 20),
                          SizedBox(width: 8.w),
                          IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              uploadAttachmentsViewModel.removeFile(file);
                            },
                          ),
                        ],
                      ),
                    );
                  }
              );
            })
          ],
        );
      },
    );
  }
}