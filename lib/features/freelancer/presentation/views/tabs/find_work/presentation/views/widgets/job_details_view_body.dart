import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/core/widgets/custom_button.dart';

class JobDetailsViewBody extends StatelessWidget {
  const JobDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      "Mind Map",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Posted 1 hour ago",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Divider(thickness: 1, color: Colors.grey),
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
                    Divider(thickness: 1, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      "Client Details",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: AssetImage(
                            Assets.assetsImagesPortraitHappySmileyMan,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "John Doe",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(CupertinoIcons.star_fill, color: Colors.amber),
                                SizedBox(width: 4.h),
                                Text(
                                  "4.5",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  "199 jobs Posted",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Divider(thickness: 1, color: Colors.grey),
                    SizedBox(height: 16.h),
            
                    Text(
                      "Attachments",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          "No Attachments",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Divider(thickness: 1, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      "About on this job",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Project Duration",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "2 weeks",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              "Proposals:",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "+5",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                      SizedBox(height: 16.h),
                      Divider(thickness: 1, color: Colors.grey),
            
            
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
      
          CustomBotton(title: "Send offer", ontap: (){}),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
