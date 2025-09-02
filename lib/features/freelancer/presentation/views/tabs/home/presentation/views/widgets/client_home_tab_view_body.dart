import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/widgets/custom_search_text_field.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/client_home_header.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_category.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_category_grid_view.dart';

class ClientHomeTabViewBody extends StatelessWidget {
  ClientHomeTabViewBody({super.key});

  final List<String> searchHintTexts = [
    "Find top freelancers",
    "Search by category",
    "Discover trending jobs",
    "Explore recent projects",
    "Search by skill or service",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClientHomeHeader(),
            SizedBox(height: 30.h),
            CustomSearchTextField(hintTexts: searchHintTexts),
            SizedBox(height: 30.h),
            ServiceCategoryGridView(),
          ],
        ),
      ),
    );
  }
}
