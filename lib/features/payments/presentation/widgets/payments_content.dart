import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/payments/presentation/widgets/bank_details_card.dart';
import 'package:taskly/features/payments/presentation/widgets/call_center_icon.dart';
import 'package:taskly/features/payments/presentation/widgets/payment_note_card.dart';
import 'package:taskly/features/payments/presentation/widgets/secure_payment_bannar.dart';

import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model_states.dart';
import '../../../shared/presentation/views/widgets/attachments_section.dart';

class PaymentsContent extends StatelessWidget {
  const PaymentsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadAttachmentsViewModel, UploadAttachmentsViewModelStates>(
      builder: (context, state) {
        final attachments = context.read<UploadAttachmentsViewModel>().uploadedAttachments;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SecurePaymentBanner(),
              SizedBox(height: 16.h),
              const BankDetailsCard(),
              SizedBox(height: 40.h),
              Divider(thickness: 1, color: ColorsManager.primary.withOpacity(0.2)),
              SizedBox(height: 16.h),
              const CallCenterIcon(),
              SizedBox(height: 16.h),
              const PaymentNoteCard(),
              SizedBox(height: 16.h),
              AttachmentsSection(
                attachmentEntity: attachments,
                isFreelancer: false,
              ),
            ],
          ),
        );
      },
    );
  }
}
