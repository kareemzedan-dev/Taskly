import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/features/messages/presentation/manager/subscribe_to_messages_view_model/subscribe_to_messages_view_model.dart';

import 'package:taskly/features/messages/presentation/widgets/chat_view_body.dart';
import 'package:taskly/features/messages/presentation/widgets/chat_with_admin_view_body.dart';
import 'package:taskly/features/messages/presentation/widgets/custom_app_bar.dart';

import '../../../../core/di/di.dart';
import '../../../attachments/presentation/manager/download_attachments_view_model/download_attachments_view_model.dart';
import '../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../../shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_view_model.dart';
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
