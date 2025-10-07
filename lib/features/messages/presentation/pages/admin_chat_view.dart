import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/features/messages/presentation/manager/send_message_view_model/send_message_view_model.dart';

import 'package:taskly/features/messages/presentation/widgets/chat_with_admin_view_body.dart';

import '../../../../core/di/di.dart';
import '../../../attachments/presentation/manager/download_attachments_view_model/download_attachments_view_model.dart';
import '../../../attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';
import '../manager/get_admin_messages_view_model/get_admin_messages_view_model.dart';
import '../manager/subscribe_to_admin_messages_view_model/subscribe_to_admin_messages_view_model.dart';

class AdminChatView extends StatelessWidget {
  const AdminChatView({
    super.key,
    required this.currentUserId,
  });

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:  (context) => getIt<UploadAttachmentsViewModel>(),),
         BlocProvider(create: (_) => getIt<DownloadAttachmentsViewModel>()),
        BlocProvider(create: (_) => getIt<SendMessageViewModel>()),
        BlocProvider(
          create: (_) => getIt<GetAdminMessagesViewModel>(),
        ),
        BlocProvider(
            create: (_) => getIt<SubscribeToAdminMessagesViewModel>()  ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Chat'),
        ) ,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ChatWithAdminViewBody(currentUserId: currentUserId)
        ),
      ),
    );
  }
}
