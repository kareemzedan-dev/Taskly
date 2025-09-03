import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/core/utils/routes_manager.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/custom_action_container.dart';

class FreelancerWorkCard extends StatelessWidget {
  const FreelancerWorkCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 2.w),
          borderRadius: BorderRadius.circular(10.r),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Posted 1 hour ago",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                  Icon(Icons.favorite_border_rounded, color: Colors.black),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                "Mind Maps",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5.h),

              IntrinsicWidth(
                child: Container(
                  height: 30.h,

                  decoration: BoxDecoration(
                    color: ColorsManager.primary.withOpacity(.5),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Mind Maps",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "I need to create a mind map for a project, please let me know if you are interested.,please let me know if you are interested",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    color: Colors.grey.shade400,
                    size: 15.sp,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "Delivery time: 1 day",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomActionContainer(
                    title: "View details",
                    icon: Icons.remove_red_eye_outlined,
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          RoutesManager.jobDetailsView,
                        ),
                  ),
                  CustomActionContainer(
                    title: "Send offers",
                    icon: Icons.send,
                    isOffer: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
