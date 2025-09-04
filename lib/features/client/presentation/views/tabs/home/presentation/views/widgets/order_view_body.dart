import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/services/supabase_service.dart';

import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/core/widgets/custom_button.dart';
import 'package:taskly/features/client/domain/entities/home/order_entity.dart';
import 'package:taskly/features/client/presentation/views/client_home_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/order_view_model/order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/order_view_model/order_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/attachments_files_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/build_text_field_widget.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/custom_drop_down.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hiring_methods_options.dart';

class OrderViewBody extends StatefulWidget {
  const OrderViewBody({super.key});

  @override
  State<OrderViewBody> createState() => _OrderViewBodyState();
}

OrderViewModel orderViewModel = getIt<OrderViewModel>();
SupabaseService supabaseService = SupabaseService();

class _OrderViewBodyState extends State<OrderViewBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderViewModel, OrderViewModelStates>(
      listener: (context, state) {
        if (state is OrderViewModelStatesLoading) {
          Center(
            child: CircularProgressIndicator(color: ColorsManager.primary),
          );
        }
        if (state is OrderViewModelStatesSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ClientHomeView()),
            (_) => false,
          );
        }
        if (state is OrderViewModelStatesError) {
          print("Order Error: ${state.message}");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
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
                buildTextField('', 1, orderViewModel.titleController),

                SizedBox(height: 28.h),
                Text(
                  "Category",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: CustomDropdown(
                    value: orderViewModel.selectedCategory,
                    items: orderViewModel.categories,

                    hint: "Select Category",
                    onChanged: (value) {
                      setState(() {
                        orderViewModel.selectedCategory = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 28.h),
                Text(
                  "Description",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: buildTextField(
                    "Write your description here",
                    10,
                    orderViewModel.descriptionController,
                  ),
                ),
                SizedBox(height: 28.h),
                Text(
                  "Deadline",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "Enter time"),
                        onChanged:
                            (val) => orderViewModel.timeController.text = val,
                      ),
                    ),
                    SizedBox(width: 8),
                    DropdownButton<String>(
                      value: orderViewModel.selectedTimeUnit,
                      items:
                          orderViewModel.timeUnits
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(
                            () => orderViewModel.selectedTimeUnit = val!,
                          ),
                    ),
                  ],
                ),

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
                    final uploadedAttachments = await Future.wait(
                      files.map((file) async {
                        final url = await supabaseService.uploadFile(file);
                        return Attachment(
                          type: file.path.split('/').last,
                          url: url,
                        );
                      }),
                    );

                    setState(() {
                      orderViewModel.attachments = uploadedAttachments;
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

                HiringMethodsOptions(),
                SizedBox(height: 16.h),
                CustomBotton(
                  title: "Submit",
                  ontap: () {
                    if (selectedHireMethodIndex == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a hiring method"),
                        ),
                      );
                      return;
                    }

                    if (selectedHireMethodIndex == 0) {
                      context.read<OrderViewModel>().placeOrder(
                        OrderEntity(
                          id: orderViewModel.orderId,
                          title: orderViewModel.titleController.text,
                          Category: orderViewModel.selectedCategory,
                          description:
                              orderViewModel.descriptionController.text,
                          attachments: orderViewModel.attachments,

                          freelancerId: null,
                          clientId: orderViewModel.clientId!,
                          serviceType: ServiceType.public,
                          budget: 0,
                          status: OrderStatus.pending,
                          deadline: orderViewModel.calculateDeadline(
                            orderViewModel.timeController.text,
                            orderViewModel.selectedTimeUnit,
                          ),

                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                      );
                    } else {
                      print("Hire Specific Freelancer selected");
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
