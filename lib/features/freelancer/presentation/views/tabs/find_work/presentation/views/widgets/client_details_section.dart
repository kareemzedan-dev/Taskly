import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
class ClientDetailsSection extends StatelessWidget {
  const ClientDetailsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          "Client Details",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.black,
              ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: const AssetImage(
                Assets.assetsImagesPortraitHappySmileyMan,
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "John Doe",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.grey.shade800,
                      ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(CupertinoIcons.star_fill, color: Colors.amber),
                    SizedBox(width: 4.h),
                    Text(
                      "4.5",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.grey.shade800,
                          ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      "199 jobs Posted",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.grey.shade800,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
