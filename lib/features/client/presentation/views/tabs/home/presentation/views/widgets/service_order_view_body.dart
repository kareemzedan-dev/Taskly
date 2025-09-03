import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskly/core/utils/app_text_styles.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/widgets/custom_button.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/custom_drop_down.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hire_method_card.dart';
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
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
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

            CustomDropdown(
              value: selectedCategory,
              items: categories,
              hint: "Select Category",
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
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
              child: TextField(
                maxLines: 10,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  hintText: "Write your description here",
                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
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
            Row(
              children: [
                Icon(Icons.attach_file, color: Colors.grey),
                SizedBox(width: 2.w),
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Center(
                      child: Text(
                        "you can attach files or images here",
                        style: AppTextStyles.bold16.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HireMethodCard(
                  icon: Icons.language,
                  title: "Public Posting",
                  subtitle: "Post your request publicly and recive multiple proposals",
                  isSelected: false,
                  onTap: () {},
                ),
                      HireMethodCard(
                  icon: FontAwesomeIcons.bullseye,
                  title: "Hire Specific Freelancer",
                  subtitle: "Send your request directly to a specific freelancer as a private offer",
                  isSelected: false,
                  onTap: () {},
                  badge: "Private",
                ),
              ],
            ),
                        SizedBox(height: 16.h),
                        CustomBotton(title: "Submit", ontap: () {},),
                                    SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
