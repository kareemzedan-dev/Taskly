import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
import 'package:taskly/features/shared/presentation/views/widgets/chat_view_body.dart';
import 'package:taskly/features/shared/presentation/views/widgets/custom_app_bar.dart';

import '../../../../../../../../core/di/di.dart';
import '../../../../../../../attachments/presentation/manager/download_attachments_view_model/download_attachments_view_model.dart';
import '../../../../../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../../../../../../shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_view_model.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    required this.userName,
    required this.userImage,
    required this.order,
    required this.currentUserId,
    required this.receiverId,
  });

  final String userName;
  final String userImage;
  final OrderEntity order;
  final String currentUserId;
  final String receiverId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<DownloadAttachmentsViewModel>(),
        ),
        BlocProvider(
          create: (_) => getIt<SubscribeOrdersRecordViewModel>()  ),
      ],
      child: Scaffold(
        appBar: customAppBar(
          context,
          userName: userName,
          userImage: userImage,
          order: order,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ChatViewBody(
            order: order,
            currentUserId: currentUserId,
            receiverId: receiverId,
          ),
        ),
      ),
    );
  }
}
