import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taskly/config/l10n/app_localizations.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/features/attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/client/presentation/views/client_home_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/place_order_view_model/place_order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/view_model/place_order_view_model/place_order_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/attachments_files_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/build_text_field_widget.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/category_drop_down.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/description_box.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hiring_methods_options.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/private_hire_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/time_input_raw.dart';

import '../../../../../../../../../core/di/di.dart';
import '../../../../../../../../../core/services/notification_service.dart';
import '../../../../../../../../attachments/data/models/attachments_dm/attachments_dm.dart';
import '../../../../../../../../attachments/presentation/manager/upload_order_attachments_view_model/upload_order_attachments_view_model.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final local = AppLocalizations.of(context)!;
    final orderViewModel = context.read<PlaceOrderViewModel>();

    orderViewModel.timeUnits = [
      local.hours,
      local.days,
      local.weeks,
    ];
    orderViewModel.selectedTimeUnit = orderViewModel.timeUnits.first;
  }

  int selectedHireMethodIndex = 0;
  List<AttachmentModel> uploadedAttachments = [];

  UploadOrderAttachmentsViewModel uploadOrderAttachmentsViewModel =
      getIt<UploadOrderAttachmentsViewModel>();

  @override
  Widget build(BuildContext context) {
    final orderViewModel = context.read<PlaceOrderViewModel>();
    final local = AppLocalizations.of(context)!;

    return BlocConsumer<PlaceOrderViewModel, PlaceOrderViewModelStates>(
      listener: (context, state) {
        if (state is PlaceOrderViewModelStatesSuccess) {
          showTemporaryMessage(
            context,
            local.order_created_success,
            MessageType.success,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const ClientHomeView(initialIndex: 1)),
            (_) => false,
          );
        }

        if (state is PlaceOrderViewModelStatesError) {
          showTemporaryMessage(
            context,
            local.somethingWentWrong,
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
                      local.title_label,
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
                      local.category_label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    CategoryDropDown(selectedCategory: widget.selectedCategory),
                    SizedBox(height: 28.h),
                    Text(
                      local.description_label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    const DescriptionBox(),
                    SizedBox(height: 28.h),
                    Text(
                      local.deadline_label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    const TimeInputRaw(),
                    SizedBox(height: 28.h),
                    Text(
                      local.attachments_label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    AttachmentsFilesSection(
                      uploadOrderAttachmentsViewModel:
                          uploadOrderAttachmentsViewModel,
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      local.hiring_method_label,
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
                    if (selectedHireMethodIndex == 1)
                      PrivateHireSection(
                        selectedId: orderViewModel.freelancerId,
                      ),
                    SizedBox(height: 16.h),
                    CustomButton(
                      title: local.submit_button,
                      ontap: () async {
                        if (orderViewModel.titleController.text.isEmpty) {
                          return showTemporaryMessage(
                            context,
                            local.error_enter_title,
                            MessageType.error,
                          );
                        }
                        if (orderViewModel.selectedCategory == null) {
                          return showTemporaryMessage(
                            context,
                            local.error_choose_category,
                            MessageType.error,
                          );
                        }
                        if (orderViewModel.descriptionController.text.isEmpty) {
                          return showTemporaryMessage(
                            context,
                            local.error_enter_description,
                            MessageType.error,
                          );
                        }
                        if (orderViewModel.timeController.text.isEmpty) {
                          return showTemporaryMessage(
                            context,
                            local.error_enter_deadline,
                            MessageType.error,
                          );
                        }
                        // if (uploadOrderAttachmentsViewModel.files.isEmpty) {
                        //   return showTemporaryMessage(
                        //     context,
                        //     local.error_add_attachments,
                        //     MessageType.error,
                        //   );
                        // }
                        if (selectedHireMethodIndex == -1) {
                          return showTemporaryMessage(
                            context,
                            local.error_select_hiring_method,
                            MessageType.error,
                          );
                        }
                        if (uploadOrderAttachmentsViewModel.files.isNotEmpty &&
                            uploadOrderAttachmentsViewModel.files.length !=
                                uploadOrderAttachmentsViewModel
                                    .uploadedFileHashes.length) {
                          return showTemporaryMessage(
                            context,
                            local.error_wait_attachments,
                            MessageType.error,
                          );
                        }

                        if (selectedHireMethodIndex == 0) {
                          await context.read<PlaceOrderViewModel>().placeOrder(
                                OrderEntity(
                                  id: orderViewModel.orderId,
                                  clientId: orderViewModel.clientId!,
                                  freelancerId: null,
                                  title: orderViewModel.titleController.text,
                                  description:
                                      orderViewModel.descriptionController.text,
                                  category: orderViewModel.selectedCategory,
                                  attachments: uploadOrderAttachmentsViewModel
                                      .uploadedAttachments,
                                  serviceType: ServiceType.public,
                                  status: OrderStatus.Pending,
                                  deadline: orderViewModel.calculateDeadline(
                                    orderViewModel.timeController.text,
                                    orderViewModel.selectedTimeUnit,
                                  ),
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                  offersCount: 0,
                                  offerId: null,
                                ),
                              );
                        } else if (selectedHireMethodIndex == 1) {
                          if (orderViewModel.freelancerId == null) {
                            return showTemporaryMessage(
                              context,
                              local.error_select_freelancer,
                              MessageType.error,
                            );
                          }
                          if (orderViewModel.freelancerId!.isNotEmpty) {
                            print(
                                '🕒 deadline => ${orderViewModel.calculateDeadline(
                              orderViewModel.timeController.text,
                              orderViewModel.selectedTimeUnit,
                            )}');

                            await context
                                .read<PlaceOrderViewModel>()
                                .placeOrder(
                                  OrderEntity(
                                    id: orderViewModel.orderId,
                                    clientId: orderViewModel.clientId!,
                                    freelancerId: orderViewModel.freelancerId,
                                    title: orderViewModel.titleController.text,
                                    description: orderViewModel
                                        .descriptionController.text,
                                    category: orderViewModel.selectedCategory,
                                    attachments: uploadOrderAttachmentsViewModel
                                        .uploadedAttachments,
                                    serviceType: ServiceType.private,
                                    status: OrderStatus.Pending,
                                    deadline: orderViewModel.calculateDeadline(
                                      orderViewModel.timeController.text,
                                      orderViewModel.selectedTimeUnit,
                                    ),
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    offersCount: 0,
                                    offerId: null,
                                  ),
                                );
                            await NotificationService().sendNotification(
                              receiverId: orderViewModel.freelancerId!,
                              title: 'طلب خاص جديد لك',
                              body:
                                  ' لقد استلمت طلب خاص جديد يمكنك الاطلاع عليه من قسم الطلبات الخاص الان .',
                            );
                          }
                        }
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
