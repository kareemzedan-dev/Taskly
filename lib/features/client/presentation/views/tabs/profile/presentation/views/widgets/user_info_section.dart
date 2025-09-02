import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/app_text_styles.dart';
import 'package:taskly/core/utils/assets_manager.dart';
 
class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return   Row(children: [
          CircleAvatar(radius: 40.r,
        backgroundImage:AssetImage(Assets.assetsImagesPortraitHappySmileyMan),

        ),
        SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('John Doe',style:AppTextStyles.bold20 ,),
            Text('johndoe@gmail.com',style:AppTextStyles.bold16.copyWith(color: Colors.grey) ,),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(CupertinoIcons.star_fill,color: Colors.amber,)
              ,Icon(CupertinoIcons.star,color: Colors.amber,)
              ,Icon(CupertinoIcons.star,color: Colors.amber,)
              ,Icon(CupertinoIcons.star,color: Colors.amber,)
              ,Icon(CupertinoIcons.star,color: Colors.amber,),
              SizedBox(width: 10.w,)
              ,Text('(1.0)',style:AppTextStyles.bold16.copyWith(color: Colors.grey) ,),

           ],)
          ],
        ),
    
    ],);
  }
}