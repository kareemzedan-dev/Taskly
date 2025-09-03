import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskly/core/utils/app_text_styles.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/widgets/custom_button.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/attachments_files_section.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/build_text_field_widget.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/custom_drop_down.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hire_method_card.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hiring_methods_options.dart';
import 'package:taskly/features/welcome/presentation/views/widgets/role_box.dart';

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

  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              "Attachments",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 16.h),
            AttachmentsFilesSection(),
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
                  print("Public Posting selected");
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
  }
}
