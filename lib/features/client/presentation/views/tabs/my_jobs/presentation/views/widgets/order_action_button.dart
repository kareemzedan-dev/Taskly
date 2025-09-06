
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';

class OrderActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final int? count; 
  final VoidCallback onTap;

  const OrderActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasCount = count != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 45.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: hasCount ? color : Colors.transparent,
          border: hasCount ? null : Border.all(color: color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: hasCount ? ColorsManager.white : color,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(
                color: hasCount ? ColorsManager.white : color,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasCount) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "$count",
                  style: TextStyle(
                    color: ColorsManager.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
