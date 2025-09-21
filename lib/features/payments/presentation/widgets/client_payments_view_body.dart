import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import 'package:taskly/features/attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model_states.dart';
import 'package:taskly/features/payments/presentation/widgets/payments_content.dart';
import 'package:taskly/features/payments/presentation/widgets/upload_payment_proof_button.dart';

class ClientPaymentsViewBody extends StatelessWidget {
  const ClientPaymentsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UploadAttachmentsViewModel>(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PaymentsContent(),
              ),
              SizedBox(height: 16.h),
              UploadAttachmentsSection(),
              SizedBox(height: 16.h),
              CustomButton(title: "Make Payment", ontap: () {}),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}


class UploadAttachmentsSection extends StatelessWidget {
  const UploadAttachmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadAttachmentsViewModel, UploadAttachmentsViewModelStates>(
      builder: (context, state) {
        if (state is UploadAttachmentsViewModelStatesLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (state is UploadAttachmentsViewModelStatesError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showTemporaryMessage(context, state.message, MessageType.error);
          });
        }
        if (state is UploadAttachmentsViewModelStatesSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showTemporaryMessage(context, "Payment proof uploaded successfully", MessageType.success);
          }
          );
        }

        return UploadPaymentProofButton(
          onTap: () {
            context.read<UploadAttachmentsViewModel>().pickFilesFromDevice(
              bucketName: "payment_attachments",
            );
          },
        );
      },
    );
  }
}
