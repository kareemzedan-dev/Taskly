import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taskly/features/attachments/presentation/manager/upload_attachments_view_model/upload_attachments_view_model.dart';

import 'package:taskly/features/messages/presentation/widgets/chat_view_body.dart';
import 'package:taskly/features/messages/presentation/widgets/custom_app_bar.dart';
import 'package:taskly/features/reviews/presentation/manager/submit_rating_view_model/submit_rating_view_model.dart';

import '../../../../config/l10n/app_localizations.dart';
import '../../../../config/routes/routes_manager.dart';
import '../../../../core/components/confirmation_dialog.dart';
import '../../../../core/di/di.dart';
import '../../../attachments/presentation/manager/download_attachments_view_model/download_attachments_view_model.dart';
import '../../../client/presentation/views/tabs/my_jobs/presentation/view_model/update_offer_status_view_model/update_offer_status_view_model.dart';
import '../../../freelancer/presentation/cubit/add_earnings_view_model/add_earnings_view_model.dart';
import '../../../freelancer/presentation/cubit/update_order_status_view_model/update_order_status_view_model.dart';
import '../../../freelancer/presentation/views/tabs/find_work/presentation/view_model/get_commission_view_model/get_commission_view_model.dart';
import '../../../reviews/presentation/manager/get_user_reviews_view_model/get_user_reviews_view_model.dart';
import '../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../../shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_view_model.dart';
import '../manager/mark_message_as_read_view_model/mark_message_as_read_view_model.dart';
import '../manager/pending_messages_view_model/pending_messages_view_model.dart';
import '../manager/user_status_view_model/user_status_states.dart';
import '../manager/user_status_view_model/user_status_view_model.dart';
import '../widgets/admin_message_card.dart';
import '../widgets/chat_header_section.dart';
import '../widgets/order_status_card.dart';

class UserChatView extends StatelessWidget {
  const UserChatView({
    super.key,
    required this.userName,
    required this.currentUserAvatar,
    required this.receiverAvatar,
    required this.order,
    required this.currentUserId,
    required this.receiverId,
  });

  final String userName;

  final OrderEntity order;
  final String currentUserAvatar;
  final String receiverAvatar;
  final String currentUserId;
  final String receiverId;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!; // <-- استدعاء الـ localization
    final viewModel = getIt<SubscribeOrdersRecordViewModel>();
    final adminMessage = viewModel.getAdminMessage(order, local);



    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<DownloadAttachmentsViewModel>()),
        BlocProvider(create: (_) => getIt<SubscribeOrdersRecordViewModel>()),
        BlocProvider(create: (_) => getIt<UpdateOrderStatusViewModel>()),
        BlocProvider(
          create: (_) => getIt<UserStatusViewModel>()..streamUserStatus(receiverId),
        ),
        BlocProvider(
          create: (context) => getIt<GetCommissionViewModel>(),
        ),
        BlocProvider(
          create: (context) => getIt<AddEarningsViewModel>(),
        ),
        BlocProvider(
          create: (context) => getIt<UpdateOfferStatusViewModel>(),
        ),
        ChangeNotifierProvider(create: (_) => PendingMessagesViewModel()),
        BlocProvider(
          create: (context) => getIt<UploadAttachmentsViewModel>(),
        ),
        BlocProvider(
          create: (_) {
            final vm = getIt<SubscribeOrdersRecordViewModel>();
            vm.subscribe(order.id);
            return vm;
          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<GetUserReviewsViewModel>();

          },
        ),
        BlocProvider(
          create: (_) {
            return getIt<MarkMessageAsReadViewModel>();

          },
        ),


      ],
      child: BlocBuilder<UserStatusViewModel, UserStatusStates>(
        builder: (context, state) {
          bool isOnline = false;
          DateTime lastSeen = DateTime.now();

          if (state is UserStatusSuccessStates) {
            isOnline = state.userStatus.isOnline;
            lastSeen = state.userStatus.lastSeen;
          }

          return Scaffold(
            appBar: customAppBar(
              context,
              userName: userName,
              userImage: receiverAvatar,
              order: order,
              isOnline: isOnline,
              lastSeen: lastSeen,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  ChatHeaderSection(
                    order: order,
                    currentUserId: currentUserId,

                  ),

                  Expanded(
                    child: ChatViewBody(
                      currentUserAvatar: currentUserAvatar,
                      receiverAvatar: receiverAvatar,
                      currentUserRole: order.clientId == currentUserId
                          ? 'client'
                          : 'freelancer',
                      receiverUserRole: order.clientId == currentUserId
                          ? 'freelancer'
                          : 'client',
                      orderId: order.id,
                      currentUserId: currentUserId,
                      receiverId: receiverId,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
