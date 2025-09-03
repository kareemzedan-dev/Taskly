import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';

class CustomActionContainer extends StatelessWidget {
  CustomActionContainer({
    super.key,
    required this.title,
    required this.icon,
    this.isOffer = false,
    this.onTap,
  });
  String title;
  IconData icon;
  bool isOffer;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2.w,),
          color: !isOffer ?Colors.white:ColorsManager.primary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isOffer) Icon(icon, color: ColorsManager.primary),
              SizedBox(width: 5.w),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color:isOffer?Colors.white: ColorsManager.primary,
                ),
              ),
                  SizedBox(width: 5.w),
              if (isOffer) Icon(icon, color: ColorsManager.white),
            ],
          ),
        ),
      ),
    );
  }
}
