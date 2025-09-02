import 'package:flutter/material.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/account_item_row.dart';
import 'package:taskly/features/client/presentation/views/tabs/profile/presentation/views/widgets/user_info_section.dart';
 
class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(children: [
        SizedBox(height: 20,),
     UserInfoSection(),
        SizedBox(height: 40,),
        AccountItemRow(image:Assets.assetsImagesChat6431892,text:    "Technical Support",  ),
        SizedBox(height: 10,),
        AccountItemRow(image:Assets.assetsImagesChat6431892,text:   "Language",  ),
  
      
      ],),
    ));
  }
}
