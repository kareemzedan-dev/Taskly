import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/app_text_styles.dart';

class AttachmentsFilesSection extends StatelessWidget {
  const AttachmentsFilesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return         Row(
              children: [
                Icon(Icons.attach_file, color: Colors.grey),
                SizedBox(width: 2.w),
                Expanded(
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Center(
                      child: Text(
                        "you can attach files or images here",
                        style: AppTextStyles.bold16.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
  }
}