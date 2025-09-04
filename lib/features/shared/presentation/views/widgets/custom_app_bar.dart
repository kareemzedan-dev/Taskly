
  import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/shared/presentation/views/widgets/custom_states_container.dart';

AppBar customAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 70.h,
      elevation: 0,
      shape: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 2),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.grey.shade500),
          onPressed: () {},
        ),
      ],
      leadingWidth: double.infinity,
      leading: Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.grey.shade500,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 8.w),
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: 20.r,
                backgroundImage: AssetImage(
                  Assets.assetsImagesPortraitHappySmileyMan,
                ),
              ),

              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Kareem Zedan",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Mind Map",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      CustomStatesContainer()
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      centerTitle: true,
    );
  }