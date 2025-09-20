import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;
  final List<int>? numbers;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
    this.numbers,
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
      tabs: List.generate(tabs.length, (index) {
        return Tab(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tabs[index]),
                SizedBox(width: 6.w),
                if (numbers != null)
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 24.w,
                      maxHeight: 24.h,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      numbers![index].toString() ,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.h);
}
