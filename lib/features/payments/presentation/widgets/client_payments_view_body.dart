import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/features/attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import 'package:taskly/features/attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/client_home_view.dart';
import 'package:taskly/features/payments/domain/entities/payment_entity.dart';
import 'package:taskly/features/payments/presentation/manager/create_payment_view_model/create_payment_view_model.dart';
import 'package:taskly/features/payments/presentation/manager/create_payment_view_model/create_payment_view_model_states.dart';
import 'package:taskly/features/payments/presentation/widgets/payments_content.dart';
import 'package:taskly/features/payments/presentation/widgets/upload_payment_proof_button.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/domain/entities/order_entity/order_entity.dart';

class ClientPaymentsViewBody extends StatelessWidget {
    ClientPaymentsViewBody({super.key, required this.order});

  final OrderEntity order;
    Uuid uuid = Uuid();

  @override
  Widget build(BuildContext context) {
 
    return MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => getIt<UploadAttachmentsViewModel>()),
    BlocProvider(create: (_) => getIt<CreatePaymentViewModel>()),
  ],
  child: Builder(
    builder: (context) {  
      final uploadVM = context.read<UploadAttachmentsViewModel>();

      return SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              const Expanded(child: PaymentsContent()),

              const UploadAttachmentsSection(),
              SizedBox(height: 16.h),

              BlocListener<CreatePaymentViewModel, CreatePaymentViewModelStates>(
                listener: (context, state) {
                  if (state is CreatePaymentViewModelStatesLoading) {
                    showTemporaryMessage(context, "Creating payment...", MessageType.waiting);
                  } else if (state is CreatePaymentViewModelStatesError) {
                    showTemporaryMessage(context, state.message, MessageType.error);
                  } else if (state is CreatePaymentViewModelStatesSuccess) {
                    showTemporaryMessage(
                      context,
                      "Payment created successfully, please wait for admin approval",
                      MessageType.success,
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientHomeView(initialIndex: 1)),
                      (route) => false,
                    );
                  }
                },
                child:CustomButton(
                title: "Make Payment",
                ontap: () {
                  if (uploadVM.files.isNotEmpty &&
                      uploadVM.files.length != uploadVM.uploadedFileHashes.length) {
                    return showTemporaryMessage(
                      context,
                      "Please wait until all attachments are uploaded",
                      MessageType.error,
                    );
                  }
                if (uploadVM.uploadedAttachments.isEmpty) {
                    return showTemporaryMessage(
                      context,
                      "Please upload payment proof",
                      MessageType.error,
                    );
                  }
        

                  final paymentId = uuid.v4();
                  context.read<CreatePaymentViewModel>().createPayment(
                    PaymentEntity(
                      id: paymentId,
                      clientId: order.clientId,
                      freelancerId:  order.freelancerId,
                      orderId: order.id,
                      attachments: uploadVM.uploadedAttachments,
                      amount: order.budget!,
                      status: "Pending",
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      paymentMethod: "",
                      accountNumber: "",
                      requesterType: "client",
                    ),
                  );
                },
              ),
              )
            ],
          ),
        ),
      );
    },
    ),
);
  
  }
}


class UploadAttachmentsSection extends StatelessWidget {
  const UploadAttachmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      UploadAttachmentsViewModel,
      UploadAttachmentsViewModelStates
    >(
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
            showTemporaryMessage(
              context,
              "Payment proof uploaded successfully",
              MessageType.success,
            );
          });
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
