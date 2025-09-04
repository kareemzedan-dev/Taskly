import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/widgets/custom_search_text_field.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/freelancer_info_card_for_hire.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/freelancer_info_list_view.dart';

class PrivateHireSection extends StatelessWidget {
  const PrivateHireSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260.h,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomSearchTextField(
                hintTexts: [
                  "Search freelancers by skill...",
                  "Choose the best match for your project",
                  "Find experts for your task",
                  "Select a freelancer to hire",
                  "Search by name or specialty",
                  "Pick the right talent for you",
                ],
              ),

              SizedBox(height: 16.h),
              FreelancerInfoListView(),
            ],
          ),
        ),
      ),
    );
  }
}
