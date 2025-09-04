import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/services/supabase_service.dart';

import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/core/widgets/custom_button.dart';
import 'package:taskly/core/widgets/dismissible_error_card.dart';
import 'package:taskly/features/client/domain/entities/home/order_entity.dart';
import 'package:taskly/features/client/presentation/views/client_home_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/order_view_model/order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/order_view_model/order_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/attachments_files_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/build_text_field_widget.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/category_drop_down.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/custom_drop_down.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/description_box.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hiring_methods_options.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/time_input_raw.dart';

class OrderViewBody extends StatefulWidget {
  const OrderViewBody({super.key});

  @override
  State<OrderViewBody> createState() => _OrderViewBodyState();
}

OrderViewModel orderViewModel = getIt<OrderViewModel>();
SupabaseService supabaseService = SupabaseService();
String errorMessage = "";

class _OrderViewBodyState extends State<OrderViewBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderViewModel, OrderViewModelStates>(
      buildWhen:
          (previous, current) =>
              current is OrderViewModelStatesLoading ||
              current is OrderViewModelStatesSuccess ||
              current is OrderViewModelStatesError,
      listener: (context, state) {
        if (state is OrderViewModelStatesLoading) {
          Center(
            child: CircularProgressIndicator(color: ColorsManager.primary),
          );
        }
        if (state is OrderViewModelStatesSuccess) {
          showTemporaryMessage(
            context,
            "Order created successfully",
            MessageType.success,
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ClientHomeView()),
            (_) => false,
          );
        }
        if (state is OrderViewModelStatesError) {
          showTemporaryMessage(
            context,
            "Something went wrong, try again later",
            MessageType.error,
          );
        }
      },

      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  "Title",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                buildTextField(
                  'Enter title',
                  1,
                  orderViewModel.titleController,
                ),

                SizedBox(height: 28.h),
                Text(
                  "Category",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                CategoryDropDown(),
                SizedBox(height: 28.h),
                Text(
                  "Description",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                DescriptionBox(),
                SizedBox(height: 28.h),
                Text(
                  "Deadline",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                TimeInputRaw(),
                SizedBox(height: 28.h),
                Text(
                  "Attachments",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                BlocConsumer<OrderViewModel, OrderViewModelStates>(
                  buildWhen:
                      (previous, current) =>
                          current is OrderViewModelStatesAttachmentsLoading ||
                          current is OrderViewModelStatesAttachmentsSuccess ||
                          current is OrderViewModelStatesAttachmentsError,
                  listener: (context, state) {
                    if (state is OrderViewModelStatesAttachmentsSuccess) {
                      orderViewModel.uploadedAttachments = state.attachments;
                      showTemporaryMessage(
                        context,
                        "Files uploaded successfully",
                        MessageType.success,
                      );
                    } else if (state is OrderViewModelStatesAttachmentsError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is OrderViewModelStatesAttachmentsLoading) {
                      return Center(
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorsManager.primary,
                        ),
                      );
                    }
                    return AttachmentsFilesSection(
                      onFilesSelected: (files) {
                        orderViewModel.localAttachments = files;
                      },
                    );
                  },
                ),
                SizedBox(height: 28.h),
                Text(
                  "Hiring Method",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),

                HiringMethodsOptions(),
                SizedBox(height: 16.h),
                CustomBotton(
                  title: "Submit",
                  ontap: () async {
                    if (orderViewModel.localAttachments.isEmpty) {
                      showTemporaryMessage(
                        context,
                        "Please add attachments",
                        MessageType.error,
                      );

                      return;
                    }

                    if (orderViewModel.timeController.text.isEmpty ||
                        orderViewModel.descriptionController.text.isEmpty ||
                        orderViewModel.localAttachments.isEmpty ||
                        orderViewModel.timeController.text.isEmpty ||
                        orderViewModel.selectedCategory!.isEmpty) {
                      return showTemporaryMessage(
                        context,
                        "Please fill all fields",
                        MessageType.error,
                      );
                    } else {
                      List<Attachment> uploadedAttachments = await context
                          .read<OrderViewModel>()
                          .uploadAttachments(orderViewModel.localAttachments);

                      await context.read<OrderViewModel>().placeOrder(
                        OrderEntity(
                          id: orderViewModel.orderId,
                          clientId: orderViewModel.clientId!,
                          freelancerId: null,
                          title: orderViewModel.titleController.text,
                          description:
                              orderViewModel.descriptionController.text,
                          Category: orderViewModel.selectedCategory,
                          attachments: uploadedAttachments,
                          serviceType: ServiceType.public,
                          status: OrderStatus.pending,
                          deadline: orderViewModel.calculateDeadline(
                            orderViewModel.timeController.text,
                            orderViewModel.selectedTimeUnit,
                          ),
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                      );
                    }
                  },
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
