import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';

import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/core/utils/colors_manger.dart';

import '../../../client/presentation/views/tabs/my_jobs/presentation/views/pdf_viewer_view.dart';
import '../manager/download_attachments_view_model/download_attachments_states.dart';
import '../manager/download_attachments_view_model/download_attachments_view_model.dart';

class AttachmentItemViewer extends StatelessWidget {
  final String attachmentName;
  final String attachmentPath;
  final bool isFreelancer;

  const AttachmentItemViewer({
    super.key,
    required this.attachmentName,
    required this.attachmentPath,
    required this.isFreelancer,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadAttachmentsViewModel, DownloadAttachmentsStates>(
      listener: (context, state) async {
        if (state is DownloadAttachmentsStatesLoading) {
          showTemporaryMessage(context, 'Downloading...', MessageType.success);
        } else if (state is DownloadAttachmentsStatesSuccess) {
          showTemporaryMessage(
              context, 'Downloaded to ${state.file.path}', MessageType.success);


          await OpenFile.open(state.file.path);
        } else if (state is DownloadAttachmentsStatesError) {
          showTemporaryMessage(context, 'Download failed: ${state.message}', MessageType.error);
        }
      },
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.all(8.w),
          margin: EdgeInsets.symmetric(vertical: 8.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: ColorsManager.primary.withValues(alpha: .5),
              width: 1.w,
            ),
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( // ⬅️ هنا
                child: Text(
                  attachmentName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // ⬅️ عشان يقص لو طويل
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye,
                        color: ColorsManager.primary, size: 18.sp),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FileViewerView(
                            filePath: File(attachmentPath).path,
                            isNetwork: true,
                          ),
                        ),
                      );
                    },
                  ),
                  if (isFreelancer)
                    IconButton(
                      icon: Icon(Icons.download, color: Colors.green, size: 18.sp),
                      onPressed: () {
                        context.read<DownloadAttachmentsViewModel>().downloadAttachments(
                          attachmentPath,
                          attachmentName,
                        );
                      },
                    ),
                ],
              ),



          ],
          ),
        ),
      ),
    );
  }
}
