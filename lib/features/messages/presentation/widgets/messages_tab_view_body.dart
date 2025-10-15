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


class UserMessagesTabViewBody extends StatefulWidget {
  const UserMessagesTabViewBody({super.key});

  @override
  State<UserMessagesTabViewBody> createState() => _UserMessagesTabViewBodyState();
}

class _UserMessagesTabViewBodyState extends State<UserMessagesTabViewBody> {
  late final GetAcceptedOrderMessageViewModel orderVM;
  late final GetConversationsViewModel convVM;
  late final UserRole userRole;

  @override
  void initState() {
    super.initState();

    userRole = SharedPrefHelper.getString(StringsManager.roleKey) == 'freelancer'
        ? UserRole.freelancer
        : UserRole.client;

    orderVM = getIt<GetAcceptedOrderMessageViewModel>();
    convVM = getIt<GetConversationsViewModel>();

    orderVM.getAcceptedOrderMessages(
      SharedPrefHelper.getString(StringsManager.idKey)!,
      role: userRole,
    );

    convVM.getConversations(
      SharedPrefHelper.getString(StringsManager.idKey)!,
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<GetAcceptedOrderMessageViewModel, GetAcceptedOrderMessageStates>(
              bloc: orderVM,
              builder: (context, orderState) {
                return BlocBuilder<GetConversationsViewModel, GetConversationsStates>(
                  bloc: convVM,
                  builder: (context, convState) {
                    final hasOrders = orderState is GetAcceptedOrderMessageStatesSuccess &&
                        orderState.orders.isNotEmpty;

                    final hasConversations = convState is GetConversationsSuccessStates &&
                        convState.conversationsList.isNotEmpty;

                    if (!hasOrders && !hasConversations) {
                      return const Center(child: Text("No messages"));
                    }

                    return Column(
                      children: [
                        if (hasOrders)
                          ListView.builder(
                            itemCount: orderState.orders.length,
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
                                  lastMessage:order.lastMessage??"مرفق",
                                  lastMessageTime: DateTime.now(),
                                  onTap: () {},
                                  onUserInfoLoaded: (fullName, avatarUrl) {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesManager.chatView,
                                      arguments: {
                                        "userName": fullName,
                                        "currentUserAvatar": SharedPrefHelper.getString(StringsManager.profileImageKey),
                                        "receiverAvatar": avatarUrl,
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
                            itemCount: convState.conversationsList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final conversation = convState.conversationsList[index];
                              final orderAlreadyExists = hasOrders &&
                                  orderState.orders.any((o) => o.id == conversation.order?.id);
                              if (orderAlreadyExists) return const SizedBox.shrink();

                              final user = conversation.user;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: MessagesCard(
                                  chatUserId: user.id,
                                  chatUserRole: user.role == "client"
                                      ? UserRole.client
                                      : UserRole.freelancer,
                                  order: conversation.order!,
                                  lastMessage: conversation.lastMessage ??"",
                                  lastMessageTime: conversation.lastMessageTime ?? DateTime.now(),
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
                                        "currentUserAvatar": SharedPrefHelper.getString(StringsManager.profileImageKey),
                                        "receiverAvatar": avatarUrl,
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
