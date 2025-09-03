import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/job_details_view_body.dart';

class JobDetailsView extends StatelessWidget {
  const JobDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.white,
      body: JobDetailsViewBody(),
    );
  }
}