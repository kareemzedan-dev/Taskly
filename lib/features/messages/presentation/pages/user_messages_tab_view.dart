import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/features/messages/presentation/widgets/messages_tab_view_body.dart';

import '../../../../core/utils/strings_manager.dart';
import '../../../shared/presentation/views/widgets/messages_card.dart';

class UserMessagesTabView extends StatelessWidget {
  const UserMessagesTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
        ),
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          GestureDetector(
            onTap: () {
       Navigator.pushNamed(context, RoutesManager.adminChatView , arguments: {
         "currentUserId": SharedPrefHelper.getString( StringsManager.idKey)
       });

            },

            child: Card(
              elevation: 10,
              child: Container(
                  width: double.infinity,
                  height: 60.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border:
                          Border.all(color: Colors.grey.shade300, width: 2.w)),
                  child: Row(children: [
                    CircleAvatar(
                        radius: 30.r, backgroundColor: Colors.grey.shade400),
                    SizedBox(width: 12.w),
                    Column(children: [
                      Text("John Doe",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              )),
                      Text("John Doe",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              )),
                    ])
                  ])),
            ),
          ),
          UserMessagesTabViewBody(),
        ],
      )),
    );
  }
}
