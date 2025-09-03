import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/widgets/custom_button.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/about_job_section.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/attachments_section.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/client_details_section.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/description_section.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/job_header_section.dart';

class JobDetailsViewBody extends StatelessWidget {
  const JobDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    JobHeader(),
                    Divider(thickness: 1, color: Colors.grey),
                    DescriptionSection(),
                    Divider(thickness: 1, color: Colors.grey),
                    ClientDetailsSection(),
                    Divider(thickness: 1, color: Colors.grey),
                    AttachmentsSection(),
                    Divider(thickness: 1, color: Colors.grey),
                    AboutJobSection(),
                  ],
                ),
              ),
            ),
          ),
          CustomBotton(title: "Send offer", ontap: () {}),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

 