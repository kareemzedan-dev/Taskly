import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';

class MessagesCard extends StatelessWidget {
  const MessagesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          radius: 30.r,
          backgroundImage: AssetImage(
            Assets.assetsImagesPortraitHappySmileyMan,
          ),
        ),
        SizedBox(width: 20.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kareem Zedan",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            Row(
              children: [
                Icon(Icons.message_outlined, color: Colors.grey.shade400),
                SizedBox(width: 4.w),

                Text(
                  "No messages yet",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        Container(
          width: 50.w,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Mind",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
