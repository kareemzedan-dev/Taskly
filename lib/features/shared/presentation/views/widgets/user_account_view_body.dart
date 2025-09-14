import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/components/custom_text_field.dart';
import 'package:taskly/core/utils/assets_manager.dart';

class UserAccountViewBody extends StatelessWidget {
  const UserAccountViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
           Center(
  child: Stack(
    children: [
      CircleAvatar(
        backgroundImage: AssetImage(
          Assets.assetsImagesPortraitHappySmileyMan,
        ),
        radius: 50.r,
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(4),
          child: Icon(
            Icons.camera_alt,
            size: 20.sp,
            color: Colors.grey[700],
          ),
        ),
      ),
    ],
  ),
),

            SizedBox(height: 16.h),
            Text(
              "User Name",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(hintText: "Kareem Zedan", keyboardType: TextInputType.name,),
              SizedBox(height: 16.h),
            Text(
              "Email Address",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
            ),
                        SizedBox(height: 8.h),
            CustomTextFormField(hintText: "zKx5S@example.com", keyboardType: TextInputType.name,),
              SizedBox(height: 16.h),
            Text(
              "Phone Number",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
            ),
                      SizedBox(height: 8.h),
            CustomTextFormField(hintText: "+20 123456789", keyboardType: TextInputType.name,),
              SizedBox(height: 16.h),
                        Text(
              "Bio",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
            ),
                      SizedBox(height: 8.h),
            CustomTextFormField(hintText: "Write something about yourself", keyboardType: TextInputType.name,),
              SizedBox(height: 50.h),
              CustomButton(title: "Save", ontap: (){},)
          ],
        ),
      ),
    );
  }
}
