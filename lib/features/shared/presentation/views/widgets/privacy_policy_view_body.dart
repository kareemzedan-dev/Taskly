import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyViewBody extends StatelessWidget {
  const PrivacyPolicyViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 16.sp,);

    final TextStyle bodyStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: Colors.black87, height: 1.5,fontSize: 14.sp,);

    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
         
          width: double.infinity,
          decoration: BoxDecoration(
                    color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.shade300, width: 2.w),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Privacy Policy", style: titleStyle),
                  SizedBox(height: 12.h),
                  Text(
                    "Welcome to Taskly! Your privacy is very important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our application, whether you are a Client or a Freelancer.",
                    style: bodyStyle,
                  ),
                  SizedBox(height: 20.h),
        
                  Text("1. Information We Collect", style: titleStyle),
                  SizedBox(height: 8.h),
                  Text(
                    "- Account Information: name, email, phone number, profile details.\n"
                    "- Service & Order Details: tasks created, accepted, and completed.\n"
                    "- Payment Information: billing details and transaction history.\n"
                    "- Device Information: device type, OS, and IP address.",
                    style: bodyStyle,
                  ),
                  SizedBox(height: 20.h),
        
                  Text("2. How We Use Your Information", style: titleStyle),
                  SizedBox(height: 8.h),
                  Text(
                    "We use your information to create and manage accounts, match Clients with Freelancers, facilitate communication, process payments, improve app performance, and ensure security.",
                    style: bodyStyle,
                  ),
                  SizedBox(height: 20.h),
        
                  Text("3. Sharing Your Data", style: titleStyle),
                  SizedBox(height: 8.h),
                  Text(
                    "We do not sell your personal data. We may share information only with:\n"
                    "- Other Users (limited profile details to complete tasks).\n"
                    "- Third-party services (Firebase, Supabase, payment processors).\n"
                    "- Legal authorities if required by law.",
                    style: bodyStyle,
                  ),
                  SizedBox(height: 20.h),
        
                  Text("4. Data Security", style: titleStyle),
                  SizedBox(height: 8.h),
                  Text(
                    "We implement industry-standard measures to protect your data, but no method of transmission or storage is 100% secure.",
                    style: bodyStyle,
                  ),
                  SizedBox(height: 20.h),
        
                  Text("5. Your Rights", style: titleStyle),
                  SizedBox(height: 8.h),
                  Text(
                    "You have the right to access, update, or delete your personal data and to contact us regarding any privacy concerns.",
                    style: bodyStyle,
                  ),
                  SizedBox(height: 20.h),
        
                  Text("6. Cookies & Tracking", style: titleStyle),
                  SizedBox(height: 8.h),
                  Text(
                    "Taskly may use cookies and similar technologies to personalize your experience and analyze app usage.",
                    style: bodyStyle,
                  ),
                  SizedBox(height: 20.h),
        
                  Text("7. Policy Updates", style: titleStyle),
                  SizedBox(height: 8.h),
                  Text(
                    "We may update this Privacy Policy from time to time. Continued use of Taskly means you agree to the updated terms.",
                    style: bodyStyle,
                  ),
                  SizedBox(height: 20.h),
        
            
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
