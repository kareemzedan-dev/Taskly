import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/upload_attachments_view_model/upload_attachments_view_model_states.dart';

import '../../../../../../../../attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../cubit/delete_attachments_view_model/delete_attachments_view_model.dart';
import '../../cubit/delete_attachments_view_model/delete_attachments_view_model_states.dart';
import '../../cubit/upload_attachments_view_model/upload_attachments_view_model.dart';
import '../../../../../../../../../core/components/dismissible_error_card.dart';

class AttachmentsFilesSection extends StatefulWidget {
  final UploadAttachmentsViewModel uploadAttachmentsViewModel;
  final VoidCallback? onTap;
  final VoidCallback? onClearAll;

  const AttachmentsFilesSection({
    super.key,
    required this.uploadAttachmentsViewModel,
    this.onTap,
    this.onClearAll,
  });

  @override
  State<AttachmentsFilesSection> createState() => _AttachmentsFilesSectionState();
}

class _AttachmentsFilesSectionState extends State<AttachmentsFilesSection> {
  late final DeleteAttachmentsViewModel deleteAttachmentsViewModel;

  @override
  void initState() {
    super.initState();
    deleteAttachmentsViewModel = getIt<DeleteAttachmentsViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.uploadAttachmentsViewModel),
        BlocProvider.value(value: deleteAttachmentsViewModel),
      ],
      child: BlocConsumer<UploadAttachmentsViewModel, UploadAttachmentsViewModelStates>(
        listener: (context, state) {
          if (state is UploadAttachmentsViewModelStatesLoading) {
            _showTemporaryMessage("Uploading...", MessageType.success);
          } else if (state is UploadAttachmentsViewModelStatesError) {
            _showTemporaryMessage(state.message, MessageType.error);
          } else if (state is UploadAttachmentsViewModelStatesSuccess) {
            _showTemporaryMessage("Uploaded Successfully ✅", MessageType.success);
          }
        },
        builder: (context, state) {
          final files = widget.uploadAttachmentsViewModel.files;
          final uploadedHashes = widget.uploadAttachmentsViewModel.uploadedFileHashes;

          return Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () async {
                      await widget.uploadAttachmentsViewModel.pickFilesFromDevice();
                    },
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onTap,
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Center(
                          child: Text(
                            widget.uploadAttachmentsViewModel.uploadedFileHashes.isEmpty
                                ? "No files uploaded yet"
                                : "${widget.uploadAttachmentsViewModel.uploadedFileHashes.length} files uploaded",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear_all, color: Colors.red),
                    onPressed: widget.onClearAll ?? () {
                      widget.uploadAttachmentsViewModel.clearFiles();
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
                  future: widget.uploadAttachmentsViewModel.generateFileHash(file),
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

                    return BlocConsumer<DeleteAttachmentsViewModel, DeleteAttachmentsViewModelStates>(
                      listener: (context, state) {
                        if (state is DeleteAttachmentsViewModelStatesError && mounted) {
                          _showTemporaryMessage(state.message, MessageType.error);
                        } else if (state is DeleteAttachmentsViewModelStatesSuccess && mounted) {
                          _showTemporaryMessage(state.message, MessageType.success);
                        }
                      },
                      builder: (context, _) => Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isUploaded ? Colors.green : Colors.grey.shade300,
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
                              onPressed: () => _onDeleteFile(file),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }

  void _onDeleteFile(File file) async {
    // Remove from local files list
    widget.uploadAttachmentsViewModel.removeFileFromQueue(file);

    final attachments = widget.uploadAttachmentsViewModel.uploadedAttachments
        .where((e) => e.name == file.path.split('/').last)
        .toList();

    if (attachments.isEmpty) {
      if (mounted) {
        _showTemporaryMessage("File not found for deletion", MessageType.error);
      }
      return;
    }

    final attachment = attachments.first;
    print('Deleting from Storage Path: ${attachment.storagePath}');

    final result = await deleteAttachmentsViewModel.deleteAttachment(attachment.storagePath);

    if (!mounted) return;

    result.fold(
          (failure) {
        _showTemporaryMessage("Failed to delete file", MessageType.error);
      },
          (_) {
        _showTemporaryMessage("File deleted successfully", MessageType.success);
        widget.uploadAttachmentsViewModel.uploadedAttachments.remove(attachment);
      },
    );
  }

  void _showTemporaryMessage(String message, MessageType type) {
    if (mounted) {
      showTemporaryMessage(context, message, type);
    }
  }
}