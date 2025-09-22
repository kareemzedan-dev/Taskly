import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/components/custom_search_text_field.dart';
import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/messages/presentation/widgets/message_card_shimmer.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/shared/presentation/views/widgets/messages_card.dart';
import 'package:taskly/features/messages/presentation/manager/get_accepted_order_message_view_model/get_accepted_order_message_view_model.dart';
import 'package:taskly/features/messages/presentation/manager/get_accepted_order_message_view_model/get_accepted_order_message_states.dart';

import '../../../../welcome/presentation/cubit/welcome_states.dart';

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
          children: [
            SizedBox(height: 16.h),

            CustomSearchTextField(
              hintTexts: [
                "Search messages_repos...",
                "Search contacts...",
                "Search groups..."
              ],
            ),

            SizedBox(height: 40.h),

            BlocBuilder<GetAcceptedOrderMessageViewModel, GetAcceptedOrderMessageStates>(
              bloc: getIt<GetAcceptedOrderMessageViewModel>()
                ..getAcceptedOrderMessages(
                  SharedPrefHelper.getString(StringsManager.idKey)!,
                  userRole,
                ),
              builder: (context, state) {
                if (state is GetAcceptedOrderMessageStatesLoading) {
                  return MessageCardShimmer();
                }
                if (state is GetAcceptedOrderMessageStatesError) {
                  return Center(child: Text("Failed to load messages"));
                }
                if (state is GetAcceptedOrderMessageStatesSuccess) {
                  if (state.orders == null || state.orders!.isEmpty) {
                    return Center(child: Text("No messages"));
                  }

                  return ListView.builder(
                    itemCount: state.orders!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final order = state.orders![index];

                      final chatUserId =
                      userRole == UserRole.client ? order.freelancerId : order.clientId;

                      final chatUserRole =
                      userRole == UserRole.client ? UserRole.freelancer : UserRole.client;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MessagesCard(
                          chatUserId: chatUserId!,
                          chatUserRole: chatUserRole,
                          order: order,
                          onTap: () {
                            if (order.status != OrderStatus.Accepted &&
                                order.status != OrderStatus.AwaitingPaymentConfirmation) {

                            } else {
                              showTemporaryMessage(
                                context,
                                "Please wait for the order payment to be confirmed",
                                MessageType.waiting,
                              );
                            }
                          },
                          onUserInfoLoaded: (fullName, avatarUrl) {

                            Navigator.pushNamed(context, RoutesManager.chatView, arguments: {
                              "userName": fullName,
                              "userImage": avatarUrl,
                              "order": order,
                            });
                          },
                        )


                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
