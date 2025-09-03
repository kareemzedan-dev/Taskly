import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/routes_manager.dart';
import 'package:taskly/core/widgets/custom_search_text_field.dart';
import 'package:taskly/features/client/presentation/views/tabs/messages/presentation/views/widgets/empty_message_widget.dart';
import 'package:taskly/features/client/presentation/views/tabs/messages/presentation/views/widgets/messages_card.dart';

class MessagesTabViewBody extends StatelessWidget {
  const MessagesTabViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasMessages = true;  

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16.h),

            CustomSearchTextField(
              hintTexts: ["Search messages...", "Search contacts...", "Search groups..."],
            ),

            SizedBox(height: 40.h),

            hasMessages 
              ? MessagesCard(onTap: () => Navigator.pushNamed(context, RoutesManager.chatView),) 
              : const EmptyMessagesWidget(),
          ],
        ),
      ),
    );
  }
}
