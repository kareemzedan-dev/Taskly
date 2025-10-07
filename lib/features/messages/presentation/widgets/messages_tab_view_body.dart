import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/shared/presentation/views/widgets/messages_card.dart';
import 'package:taskly/features/messages/presentation/manager/get_accepted_order_message_view_model/get_accepted_order_message_view_model.dart';
import 'package:taskly/features/messages/presentation/manager/get_accepted_order_message_view_model/get_accepted_order_message_states.dart';

import '../../../welcome/presentation/cubit/welcome_states.dart';
import '../manager/get_conversations_view_model/get_conversations_states.dart';
import '../manager/get_conversations_view_model/get_conversations_view_model.dart';
class UserMessagesTabViewBody extends StatelessWidget {
  const UserMessagesTabViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = SharedPrefHelper.getString(StringsManager.roleKey) == 'freelancer'
        ? UserRole.freelancer
        : UserRole.client;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            BlocBuilder<GetAcceptedOrderMessageViewModel, GetAcceptedOrderMessageStates>(
              bloc: getIt<GetAcceptedOrderMessageViewModel>()
                ..getAcceptedOrderMessages(
                  SharedPrefHelper.getString(StringsManager.idKey)!,
                  role: userRole,
                ),
              builder: (context, orderState) {

                return BlocBuilder<GetConversationsViewModel, GetConversationsStates>(
                  bloc: getIt<GetConversationsViewModel>()
                    ..getConversations(
                      SharedPrefHelper.getString(StringsManager.idKey)!,
                    ),
                  builder: (context, convState) {

                    // تحقق من وجود بيانات في الاتنين
                    final hasOrders = orderState is GetAcceptedOrderMessageStatesSuccess && orderState.orders.isNotEmpty;

                    final hasConversations = convState is GetConversationsSuccessStates &&
                        convState.conversationsList.isNotEmpty;

                    // لو الاتنين فاضيين
                    if (!hasOrders && !hasConversations) {
                      return const Center(child: Text("No messages"));
                    }
                    return Column(
                      children: [
                        if (hasOrders)
                          ListView.builder(
                            itemCount: (orderState).orders.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final order = orderState.orders[index];
                              final chatUserId = userRole == UserRole.client
                                  ? order.freelancerId
                                  : order.clientId;
                              final chatUserRole = userRole == UserRole.client
                                  ? UserRole.freelancer
                                  : UserRole.client;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: MessagesCard(
                                  chatUserId: chatUserId!,
                                  chatUserRole: chatUserRole,
                                  order: order,
                                  onTap: () {},
                                  onUserInfoLoaded: (fullName, avatarUrl) {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesManager.chatView,
                                      arguments: {
                                        "userName": fullName,
                                        "userImage": avatarUrl,
                                        "order": order,
                                        "currentUserId": SharedPrefHelper.getString(StringsManager.idKey)!,
                                        "receiverId": chatUserId,
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                        if (hasConversations)
                          ListView.builder(
                            itemCount: (convState).conversationsList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final conversation = convState.conversationsList[index];

                              // ⛔️ فلترة: لو الـ order.id ظهر قبل كده في orders → ما نعرضوش
                              final orderAlreadyExists = hasOrders &&
                                  (orderState)
                                      .orders
                                      .any((o) => o.id == conversation.order?.id);

                              if (orderAlreadyExists) {
                                return const SizedBox.shrink(); // مظهرهوش
                              }

                              final user = conversation.user;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: MessagesCard(
                                  chatUserId: user.id,
                                  chatUserRole: user.role == "client"
                                      ? UserRole.client
                                      : UserRole.freelancer,
                                  order: conversation.order!,
                                  onTap: () {},
                                  onUserInfoLoaded: (fullName, avatarUrl) {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesManager.chatView,
                                      arguments: {
                                        "userName": fullName,
                                        "userImage": avatarUrl,
                                        "order": conversation.order,
                                        "currentUserId": SharedPrefHelper.getString(StringsManager.idKey)!,
                                        "receiverId": user.id,
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                      ],
                    );

                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
