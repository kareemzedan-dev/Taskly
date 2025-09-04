import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/shared/presentation/views/widgets/admin_message_card.dart';
import 'package:taskly/features/shared/presentation/views/widgets/chat_input_field.dart';
import 'package:taskly/features/shared/presentation/views/widgets/message_bubble.dart';
import 'package:taskly/features/shared/presentation/views/widgets/order_status_card.dart';

class ChatViewBody extends StatelessWidget {
  const ChatViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrderStatusCard(
          price: 4000,
          status: "In Progress",
          onButtonPressed: () {},
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                AdminMessageCard(),
                SizedBox(height: 16.h),
                MessageBubble(
                  sender: SenderType.freelancer,
                  message: "Hello, My name is Kareem, I need to order some tasks",
                  avatarUrl: Assets.assetsImagesPortraitHappySmileyMan,
                  time: "9:00",
                ),
                SizedBox(height: 16.h),
                MessageBubble(
                  sender: SenderType.client,
                  message: "Hello, kareem, how are you?",
                  avatarUrl: Assets.assetsImagesPortraitHappySmileyMan,
                  time: "10:10",
                ),
              ],
            ),
          ),
        ),

        ChatInputField(),
        SizedBox(height: 16.h),
      ],
    );
  }
}
