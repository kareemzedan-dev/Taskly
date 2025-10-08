






import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/components/custom_search_text_field.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/freelancer_info_list_view.dart';

import '../../view_model/fetch_all_freelancers_view_model/fetch_all_freelancers_view_model.dart';
class PrivateHireSection extends StatelessWidget {
  PrivateHireSection({super.key, required this.selectedId});
  String? selectedId;

  @override
  Widget build(BuildContext context) {
    final viewModel = getIt<FetchAllFreelancersViewModel>()..getAllFreelancer();

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
          child: BlocProvider(
            create: (_) => viewModel,
            child: Column(
              children: [
                CustomSearchTextField(
                  hintTexts: [
                    "Search freelancers by name...",
                    "choose the best match for your project"
                  ],
                  onChanged: (query) {
                    viewModel.searchFreelancers(query);
                  },
                ),
                SizedBox(height: 16.h),
                FreelancerInfoListView(selectedId: selectedId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
