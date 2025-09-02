import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/service_category.dart';

class ServiceCategoryGridView extends StatelessWidget {
  const ServiceCategoryGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {
        "title": "Mind Maps",
        "icon": Icons.account_tree,
        "color": Colors.blue,
        "buttonText": "Explore",
      },
      {
        "title": "Task Management",
        "icon": Icons.task_alt,
        "color": Colors.green,
        "buttonText": "Start",
      },
      {
        "title": "Notes",
        "icon": Icons.note_alt,
        "color": Colors.orange,
        "buttonText": "Open",
      },
      {
        "title": "Calendar",
        "icon": Icons.calendar_month,
        "color": Colors.purple,
        "buttonText": "View",
      },
      {
        "title": "Reminders",
        "icon": Icons.alarm,
        "color": Colors.red,
        "buttonText": "Check",
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: services.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final service = services[index];
          return ServiceCategory(
            topColor: service["color"],
            title: service["title"],
            icon: service["icon"],
            buttonText: service["buttonText"],
            onTap: () {
              debugPrint("${service["title"]} clicked");
            },
          );
        },
      ),
    );
  }
}
