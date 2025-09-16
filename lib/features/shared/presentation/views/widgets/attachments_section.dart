import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../client/data/models/home/attaachments_dm.dart';
import '../../../../client/domain/entities/home/attaachments_entity.dart';
import '../../../../client/presentation/views/tabs/my_jobs/presentation/views/widgets/attachment_card_viewer.dart';
import '../../../../client/presentation/views/tabs/my_jobs/presentation/views/widgets/attachment_card_viewer_list_view.dart';

class AttachmentsSection extends StatelessWidget {
  const AttachmentsSection({super.key,required this.attachmentEntity});
  final List<AttachmentModel> attachmentEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Attachments",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: AttachmentCardViewerListView(attachmentEntity: attachmentEntity,),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
