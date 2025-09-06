import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/core/widgets/custom_button.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/delivery_info.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/description_section.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/input_with_drop_down.dart';

class SendOfferViewBody extends StatelessWidget {
   SendOfferViewBody({super.key});

  String selectedCurrency = "USD";
  final List<String> currencies = ["USD", "EUR", "EGP"];

  String selectedTimeUnit = "Days";
  final List<String> timeUnits = ["Hours", "Days", "Weeks"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  _buildSectionTitle(context, "Project Details :"),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300, width: 2.w),
                          borderRadius: BorderRadius.circular(10.r),
                          color: ColorsManager.primary.withOpacity(.4)
                          ),
                        child: Text(
                          "Mind Maps",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: Colors.black,
                              ),
                        ),
                      ),
                      const DeliveryInfo(),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  const DescriptionSection(),
                  SizedBox(height: 16.h),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: 16.h),

                  _buildSectionTitle(context, "Proposal Description : "),
                  SizedBox(height: 8.h),
                  _buildDescriptionBox(context),
                  SizedBox(height: 16.h),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: 16.h),

                  _buildSectionTitle(context, "Proposal Price : "),
                  SizedBox(height: 8.h),
                  InputWithDropdown(
                    hint: "Enter price",
                    selectedValue: selectedCurrency,
                    items: currencies,
                    onChanged: (val) => selectedCurrency = val!,
                  ),
                  SizedBox(height: 16.h),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: 16.h),

                  _buildSectionTitle(context, "Delivery Time : "),
                  SizedBox(height: 8.h),
                  InputWithDropdown(
                    hint: "Enter time",
                    selectedValue: selectedTimeUnit,
                    items: timeUnits,
                    onChanged: (val) => selectedTimeUnit = val!,
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
          CustomBotton(title: "Send offer", ontap: () {}),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: Colors.black,
          ),
    );
  }

  Widget _buildDescriptionBox(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          maxLines: null,
          expands: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText:
                "Explain how you will execute this project, including methods or any specific conditions....",
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Colors.grey.shade800,
                ),
          ),
        ),
      ),
    );
  }
}
 