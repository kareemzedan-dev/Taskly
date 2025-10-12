import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/l10n/app_localizations.dart';
import '../../../../attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../../../attachments/presentation/widgets/attachment_card_viewer_list_view.dart';

class AttachmentsSection extends StatelessWidget {
  const AttachmentsSection({
    super.key,
    required this.attachmentEntity,
    required this.isFreelancer,
  });

  final List<AttachmentModel> attachmentEntity;
  final bool isFreelancer;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          local.attachments,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,

          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade500,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: AttachmentCardViewerListView(
            attachmentEntity: attachmentEntity,
            isFreelancer: isFreelancer
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
