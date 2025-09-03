import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          "Description",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.black,
              ),
        ),
        SizedBox(height: 8.h),
        Text(
          "We are looking for a creative and detail-oriented freelancer to help us design a comprehensive and visually appealing mind map. The goal of this project is to organize a large amount of scattered information into a structured and easy-to-understand format. The ideal candidate should be able to translate complex ideas into clear visual diagrams, ensuring that the final mind map is both professional and user-friendly. \n\n"
          "The project requires not only strong design skills but also excellent communication, as we will be sharing raw notes, documents, and brainstorming ideas that need to be refined into meaningful categories and subcategories. Familiarity with productivity tools, educational design, or business planning mind maps will be considered a plus. \n\n"
          "The final deliverable should be delivered in high-resolution format and editable, so we can make future updates if needed. Creativity, attention to detail, and the ability to deliver within deadlines are crucial for this role. If you have previous samples of similar work, please include them in your proposal. This will be an ongoing collaboration for the right freelancer, as we have multiple upcoming projects that require clear visual structuring and design expertise.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                height: 1.5,
                color: Colors.grey.shade800,
              ),
          softWrap: true,
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}