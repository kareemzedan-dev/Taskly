import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/components/custom_tab_bar.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/my_jobs/presentation/views/widgets/my_jobs_tab_view_body.dart';

import '../../../../../../../../config/l10n/app_localizations.dart';

class FreelancerMyJobsTabView extends StatelessWidget {
  const FreelancerMyJobsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 2),
          ),
          title: Text(
            local.manageOrders,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
          ),
          bottom:   CustomTabBar(
            tabs: [local.pending, local.accepted, local.completed, local.rejected],
          ),
        ),
        backgroundColor: Colors.white,
        body: const MyJobsTabViewBody(),
      ),
    );
  }
}
