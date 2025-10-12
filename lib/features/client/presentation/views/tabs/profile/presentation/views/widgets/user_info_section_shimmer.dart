import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoSectionShimmer extends StatelessWidget {
  const UserInfoSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80.r,
            height: 80.r,
            decoration: const BoxDecoration(

              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120.w,
                height: 16.h,

              ),
              SizedBox(height: 8.h),
              Container(
                width: 180.w,
                height: 14.h,

              ),
              SizedBox(height: 8.h),
              Container(
                width: 100.w,
                height: 14.h,

              ),
              SizedBox(height: 8.h),
              Container(
                width: 140.w,
                height: 14.h,

              ),
            ],
          )
        ],
      ),
    );
  }
}
