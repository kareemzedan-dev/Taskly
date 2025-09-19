import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/client/presentation/views/client_home_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/place_order_view_model/place_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/place_order_view_model/place_order_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/attachments_files_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/build_text_field_widget.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/category_drop_down.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/description_box.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hiring_methods_options.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/private_hire_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/time_input_raw.dart';

import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../../attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../cubit/upload_attachments_view_model/upload_attachments_view_model.dart';

class OrderViewBody extends StatefulWidget {
  const OrderViewBody({
    super.key,
    required this.title,
    required this.selectedCategory,
  });

  final String title, selectedCategory;

  @override
  State<OrderViewBody> createState() => _OrderViewBodyState();
}

class _OrderViewBodyState extends State<OrderViewBody> {
  @override
  void initState() {
    super.initState();
    final orderViewModel = context.read<PlaceOrderViewModel>();
    orderViewModel.titleController.text = widget.title;
    orderViewModel.selectedCategory = widget.selectedCategory;
  }

  int selectedHireMethodIndex = -1;
  List<AttachmentModel> uploadedAttachments = [];

  UploadAttachmentsViewModel uploadAttachmentsViewModel = getIt<UploadAttachmentsViewModel>();

  @override
  Widget build(BuildContext context) {
    final orderViewModel = context.read<PlaceOrderViewModel>();
    return BlocConsumer<PlaceOrderViewModel, PlaceOrderViewModelStates>(
      listener: (context, state) {
        if (state is PlaceOrderViewModelStatesSuccess) {
          showTemporaryMessage(
            context,
            "Order created successfully",
            MessageType.success,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ClientHomeView(initialIndex: 1)),
                (_) => false,
          );

        }

        if (state is PlaceOrderViewModelStatesError) {
          showTemporaryMessage(
            context,
            "Something went wrong, try again later",
            MessageType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is PlaceOrderViewModelStatesLoading;

        return Stack(
          children: [
            SingleChildScrollView(
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
                      widget.title,
                      1,
                      orderViewModel.titleController,

                      (value) {
                        orderViewModel.titleController.text = value!;
                      },
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
                    CategoryDropDown(selectedCategory: widget.selectedCategory),

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

                    AttachmentsFilesSection(
                      uploadAttachmentsViewModel: uploadAttachmentsViewModel,
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
                    HiringMethodsOptions(
                      selectedIndex: selectedHireMethodIndex,
                      onChanged: (val) {
                        setState(() {
                          selectedHireMethodIndex = val;
                        });
                      },
                    ),

                    SizedBox(height: 16.h),
                    if (selectedHireMethodIndex == 1) PrivateHireSection(),
                    SizedBox(height: 16.h),
                    CustomButton(
                      title: "Submit",
                      ontap: () async {


                        if (orderViewModel.titleController.text.isEmpty) {
                          return showTemporaryMessage(
                            context,
                            "Please enter title",
                            MessageType.error,
                          );
                        }
                        if (orderViewModel.selectedCategory == null) {
                          return showTemporaryMessage(
                            context,
                            "Please choose category",
                            MessageType.error,
                          );
                        }
                        if (orderViewModel.descriptionController.text.isEmpty) {
                          return showTemporaryMessage(
                            context,
                            "Please enter description",
                            MessageType.error,
                          );
                        }
                        if (orderViewModel.timeController.text.isEmpty) {
                          return showTemporaryMessage(
                            context,
                            "Please enter deadline",
                            MessageType.error,
                          );
                        }
                        if (uploadAttachmentsViewModel.files.isEmpty) {
                          return showTemporaryMessage(
                            context,
                            "Please add attachments",
                            MessageType.error,
                          );
                        }
                        if (selectedHireMethodIndex == -1) {
                          return showTemporaryMessage(
                            context,
                            "Please select hiring method",
                            MessageType.error,
                          );
                        }
                        if (uploadAttachmentsViewModel.files.isNotEmpty &&
                            uploadAttachmentsViewModel.files.length != uploadAttachmentsViewModel.uploadedFileHashes.length) {
                          return showTemporaryMessage(
                            context,
                            "Please wait until all attachments are uploaded",
                            MessageType.error,
                          );
                        }


                        await context.read<PlaceOrderViewModel>().placeOrder(
                          OrderEntity(
                            id: orderViewModel.orderId,
                            clientId: orderViewModel.clientId!,
                            freelancerId: null,
                            title: orderViewModel.titleController.text,
                            description:
                            orderViewModel.descriptionController.text,
                            category: orderViewModel.selectedCategory,
                            attachments: uploadAttachmentsViewModel.uploadedAttachments,
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
                      },
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: ColorsManager.primary,
                    size: 60,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
