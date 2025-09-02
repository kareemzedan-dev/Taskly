import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/my_jobs_tab_view_body.dart';

class MyJobsTabView extends StatelessWidget {
  const MyJobsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0, 
  shape: Border(
    bottom: BorderSide(
      color: Colors.grey.shade300,
      width: 2,  
    ),
  ),
  title: Text(
    'Manage Orders',
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
        ),
  ),
),

      backgroundColor: Colors.white,
      body: SafeArea(child: MyJobsTabViewBody()),
    );
  }
}
