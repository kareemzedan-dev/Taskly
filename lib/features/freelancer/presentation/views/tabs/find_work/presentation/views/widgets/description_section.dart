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
          "We are looking for a creative and detail-oriented freelancer to help us design a comprehensive and visually appealing mind map. The goal of this project is to organize a large amount of scattered information into a structured and easy-to-understand format. The ideal candidate should be able to translate complex ideas into clear visual diagrams, ensuring that the final mind map is both professional and user-friendly. \n\n",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                height: 1.5,
                color: Colors.grey.shade800,
              ),
          softWrap: true,
        ),
         
      ],
    );
  }
}