import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/shared/presentation/views/widgets/faq_card.dart';

class TechnicalSupportViewBody extends StatelessWidget {
  const TechnicalSupportViewBody({super.key});

  final List<Map<String, String>> faqs = const [
    {
      "question": "How to request a service?",
      "answer":
          "To request a service, go to the services page, choose the service you need, fill in the details, and submit your request."
    },
    {
      "question": "How to delete a service request?",
      "answer":
          "To delete a service request, go to the 'My Jobs' tab, find your request under 'Pending', open it, and tap the delete button. Confirm to remove it."
    },
    {
      "question": "How to contact support?",
      "answer":
          "You can contact us via phone, email, or send a message through the Contact Us section above."
    },
    {
      "question": "How to chat directly with the admin?",
      "answer":
          "To chat directly with the admin, go to the 'Messages' tab. You will find a pinned chat where you can send your messages and get a response from the admin."
    },
    {
      "question": "How to update my profile?",
      "answer":
          "Go to your profile page, click edit, and update your name, email, or password as needed."
    },
    {
      "question": "How to change my password?",
      "answer": "Go to your profile page, click edit, and update your password as needed."
    },
    {
      "question": "How to change my name?",
      "answer": "Go to your profile page, click edit, and update your name as needed."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Contact Us",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 16.h),
            Card(
              elevation: 10,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Us on :",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Icon(Icons.phone, color: ColorsManager.primary),
                          SizedBox(width: 10.w),
                          Text(
                            "011 000 0000",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Icon(Icons.phone, color: ColorsManager.primary),
                          SizedBox(width: 10.w),
                          Text(
                            "111",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        " Or send us a message on :",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Icon(Icons.email, color: ColorsManager.primary),
                          SizedBox(width: 10.w),
                          Text(
                            "qN2bS@example.com",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Text("FAQ", style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 16.h),
            // FAQ List
            ...faqs.map(
              (faq) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: FAQCard(
                  question: faq['question']!,
                  answer: faq['answer']!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
