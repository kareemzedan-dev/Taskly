import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: labelColor ?? ColorsManager.primary,
      unselectedLabelColor: unselectedLabelColor ?? Colors.grey,
      labelStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      indicatorColor: indicatorColor ?? ColorsManager.primary,
      indicatorWeight: 4,
      tabs: tabs.map((title) => Tab(text: title)).toList(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.h);
}
