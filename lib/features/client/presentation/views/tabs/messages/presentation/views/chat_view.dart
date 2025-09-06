import 'package:flutter/material.dart';
 
import 'package:taskly/features/shared/presentation/views/widgets/chat_view_body.dart';
import 'package:taskly/features/shared/presentation/views/widgets/custom_app_bar.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      backgroundColor: Colors.white,
      body: SafeArea(child: ChatViewBody()),
    );
  }
 
}
