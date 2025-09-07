import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/description_box.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hiring_methods_options.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/private_hire_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/time_input_raw.dart';

OrderViewModel orderViewModel = getIt<OrderViewModel>();
SupabaseService supabaseService = SupabaseService();

class OrderViewBody extends StatefulWidget {
  const OrderViewBody({super.key,required this.title,required this.selectedCategory});
  final String title ,selectedCategory;

  @override
  State<OrderViewBody> createState() => _OrderViewBodyState();
}

class _OrderViewBodyState extends State<OrderViewBody> {
  @override
  void initState() {
    super.initState();
    orderViewModel.clearUploadProgress();
  }

  int selectedHireMethodIndex = -1;
  List<Attachment> uploadedAttachments = [];
  Map<String, double> uploadProgress = {};
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderViewModel, OrderViewModelStates>(
      listener: (context, state) {
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

        if (state is OrderViewModelStatesAttachmentsError) {
          showTemporaryMessage(context, state.message, MessageType.error);
        }
        if (state is OrderViewModelStatesAttachmentsProgress) {
          setState(() {
            uploadProgress = state.progressMap;
          });
        }
      },
      builder: (context, state) {
        final isLoading =
            state is OrderViewModelStatesLoading ||
            state is OrderViewModelStatesAttachmentsLoading;

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
                        orderViewModel.titleController.text = value ?? widget.title;
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
                    CategoryDropDown(selectedCategory: widget.selectedCategory,),

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
                      onFilesSelected: (files) async {
                        orderViewModel.localAttachments = files;
                        orderViewModel.clearUploadProgress();
                        uploadedAttachments = await context
                            .read<OrderViewModel>()
                            .uploadAttachments(orderViewModel.localAttachments);
                      },
                      uploadProgress: uploadProgress,
                      onClearAll: () {
                        orderViewModel.clearUploadProgress();
                        setState(() {
                          uploadProgress.clear();
                        });
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
                    CustomBotton(
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
                        if (orderViewModel.localAttachments.isEmpty) {
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
                        if (uploadedAttachments.isEmpty) {
                          return showTemporaryMessage(
                            context,
                            "Please upload attachments",
                            MessageType.error,
                          );
                        }

                        if (!context
                            .read<OrderViewModel>()
                            .areAllAttachmentsUploaded()) {
                          return showTemporaryMessage(
                            context,
                            "Please wait until all attachments are uploaded",
                            MessageType.error,
                          );
                        }

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
