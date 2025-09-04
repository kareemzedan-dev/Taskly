import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskly/core/helper/calculate_deadline.dart';
import 'package:taskly/core/helper/shared_preferences.dart';
import 'package:taskly/core/utils/app_text_styles.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/core/widgets/custom_button.dart';
import 'package:taskly/features/client/domain/entities/home/order_entity.dart';
import 'package:taskly/features/client/presentation/views/client_home_view.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/order_view_model/order_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/order_view_model/order_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/attachments_files_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/build_text_field_widget.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/custom_drop_down.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hire_method_card.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hiring_methods_options.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/input_with_drop_down.dart';
import 'package:taskly/features/welcome/presentation/views/widgets/role_box.dart';
import 'package:uuid/uuid.dart';

class ServiceOrderViewBody extends StatefulWidget {
  const ServiceOrderViewBody({super.key});

  @override
  State<ServiceOrderViewBody> createState() => _ServiceOrderViewBodyState();
}

class _ServiceOrderViewBodyState extends State<ServiceOrderViewBody> {
  TextEditingController titleController = TextEditingController(
    text: "Mind Map",
  );

  final List<String> categories = [
    "Design",
    "Development",
    "Marketing",
    "Writing",
  ];
  List<Attachment> attachments = [];

  TextEditingController timeController = TextEditingController();
  final orderId = Uuid().v4();

  String selectedTimeUnit = "Days";
  final List<String> timeUnits = ["Hours", "Days", "Weeks"];
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();
  final clientId = SharedPrefHelper.getString("id");

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
                buildTextField('', 1, titleController),

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
                    value: selectedCategory,
                    items: categories,

                    hint: "Select Category",
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
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
                    descriptionController,
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
                        onChanged: (val) => timeController.text = val,
                      ),
                    ),
                    SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedTimeUnit,
                      items:
                          timeUnits
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(() => selectedTimeUnit = val!),
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
                  onFilesSelected: (files) {
                    setState(() {
                      attachments =
                          files
                              .map(
                                (file) => Attachment(
                                  type: file.path.split('/').last,
                                  url: file.path,
                                ),
                              )
                              .toList();
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
                          id: orderId,
                          title: titleController.text,
                          Category: selectedCategory,
                          description: descriptionController.text,
                          attachments: attachments  ,

                          freelancerId: null,
                          clientId: clientId!,
                          serviceType: ServiceType.public,
                          budget: 0,
                          status: OrderStatus.pending,
                          deadline: calculateDeadline(
                            timeController.text,
                            selectedTimeUnit,
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
