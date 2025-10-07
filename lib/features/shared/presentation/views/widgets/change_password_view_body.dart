import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/components/custom_text_field.dart';

class ChangePasswordViewBody extends StatelessWidget {
  const ChangePasswordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Change Password",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Enter your old password then enter your new password to change your password.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
                 SizedBox(height: 30.h),
    
                 CustomTextFormField(hintText: "Old Password", iconShow: true, keyboardType: TextInputType.visiblePassword,),
                 SizedBox(height: 20.h),
                 CustomTextFormField(hintText: "New Password", iconShow: true, keyboardType: TextInputType.visiblePassword,),
                 SizedBox(height: 20.h),
                 CustomTextFormField(hintText: "Confirm New Password", iconShow: true, keyboardType: TextInputType.visiblePassword,),
    const Spacer(),
    CustomButton(title: "Change Password", ontap: (){}),
     SizedBox(height: 20.h),
      
        ],
      ),
    );
  }
}
