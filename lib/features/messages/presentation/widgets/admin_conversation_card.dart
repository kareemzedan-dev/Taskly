import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/assets_manager.dart';

class AdminConversationCard extends StatelessWidget {
  const AdminConversationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 3,
        child: Container(
            width: double.infinity,
            padding:  EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),

            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300, width: 2.w)),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
              CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.grey.shade400,
                  backgroundImage: AssetImage(Assets.assetsAdminAvatar)),
              SizedBox(width: 12.w),
              Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("Admin Support",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        )),
                Text("Chat with Admin Support",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                      color: Colors.grey.shade600,

                        )),
              ]),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                  size: 16.sp,)
            ])),
      ),
    );
  }
}
