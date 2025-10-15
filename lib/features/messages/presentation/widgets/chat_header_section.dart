// chat/presentation/widgets/chat_header_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/core/components/custom_button.dart';
import 'package:taskly/core/components/confirmation_dialog.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/services/notification_service.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/update_offer_status_view_model/update_offer_status_view_model.dart';
import 'package:taskly/features/freelancer/presentation/cubit/add_earnings_view_model/add_earnings_view_model.dart';
import 'package:taskly/features/freelancer/presentation/cubit/update_order_status_view_model/update_order_status_view_model.dart';
import 'package:taskly/features/reviews/presentation/manager/get_user_reviews_view_model/get_user_reviews_states.dart';
import 'package:taskly/features/reviews/presentation/manager/get_user_reviews_view_model/get_user_reviews_view_model.dart';
import 'package:taskly/features/reviews/presentation/widgets/rating_bottom_sheet.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_view_model.dart';
import 'package:taskly/features/messages/presentation/widgets/admin_message_card.dart';
import 'package:taskly/core/di/di.dart';
import '../../../../config/l10n/app_localizations.dart';
import '../../../reviews/presentation/manager/submit_rating_view_model/submit_rating_view_model.dart';
import '../../../shared/presentation/manager/subscribe_to_order_record_view_model/subscribe_to_order_record_states.dart';
import 'order_status_card.dart';

class ChatHeaderSection extends StatelessWidget {
  final OrderEntity order;
  final String currentUserId;

  const ChatHeaderSection({
    super.key,
    required this.order,
    required this.currentUserId,
  });

  void _showRatingBottomSheet(BuildContext context, OrderEntity order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => getIt<SubmitRatingViewModel>(),
        child: RatingBottomSheet(
          order: order,
          currentUserId: currentUserId,
          receiverId: order.clientId!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return BlocBuilder<SubscribeOrdersRecordViewModel, OrderViewModelState>(
      builder: (context, state) {
        final orderData = state is OrderSuccess ? state.order : order;
        final viewModel = context.read<SubscribeOrdersRecordViewModel>();
        final adminMessage = viewModel.getAdminMessage(orderData, local);
        final buttonText =
            viewModel.getActionButtonText(orderData, currentUserId, local);

        final freelancerRatingButton = orderData.status.name == "Completed" &&
            currentUserId == order.freelancerId;

        return Column(
          children: [
            OrderStatusCard(
              price: orderData.budget ?? 0,
              status: orderData.status.name,
              message: "",
              buttonText: buttonText,
              onButtonPressed: buttonText != null
                  ? () {
                      if (buttonText ==
                          local.payNowButton(orderData.budget.toString())) {
                        Navigator.pushNamed(
                          context,
                          RoutesManager.clientPaymentsView,
                          arguments: {'orderEntity': orderData},
                        );
                      } else if (buttonText == local.submitDeliveryButton) {
                        showConfirmationDialog(
                          context: context,
                          title: local.submitDeliveryButton,
                          message: local.submitDeliveryConfirmation,
                          onConfirm: () {
                            context
                                .read<UpdateOrderStatusViewModel>()
                                .updateOrderStatus(orderData.id, "Waiting");
                            NotificationService().sendNotification(
                              receiverId: orderData.clientId,
                              title: "تحديث حاله الطلب",
                              body:
                                  "تم تسليم العمل من جانب المستقل,من فضلك قم بمراجعه العمل وتأكيد الاستلام",
                            );
                          },
                          onCancel: () {},
                        );
                      } else if (buttonText == local.workReceivedButton) {
                        showConfirmationDialog(
                          context: context,
                          title: local.workReceivedButton,
                          message: local.workReceivedConfirmation,
                          onConfirm: () {
                            context.read<UpdateOfferStatusViewModel>()
                              ..updateOfferStatus(
                                  orderData.offerId!, "Completed");
                            context
                                .read<UpdateOrderStatusViewModel>()
                                .updateOrderStatus(orderData.id, "Completed");
                            double formattedPrice = double.parse(orderData.budget!.toStringAsFixed(2));
                            context.read<AddEarningsViewModel>().addEarnings(
                              orderData.freelancerId!,
                              formattedPrice,
                              orderData.clientId,
                            );

                            _showRatingBottomSheet(context, orderData);
                            NotificationService().sendNotification(
                              receiverId: orderData.freelancerId!,
                              title: "تحديث حاله الطلب",
                              body:
                                  " تم تأكيد استلام طلب ${orderData.title} من جانب العميل , يمكنك تقييم العمل مع الان ",
                            );
                          },
                        );
                      }
                      if (buttonText == local.rateClient) {
                        _showRatingBottomSheet(context, orderData);
                      }
                      if (buttonText == local.rateFreelancer) {
                        _showRatingBottomSheet(context, orderData);
                      }


                    }
                  : null,
            ),
            if (freelancerRatingButton)
              BlocBuilder<GetUserReviewsViewModel, GetUserReviewsStates>(
                builder: (context, reviewState) {
                  if (reviewState is GetUserReviewsLoading) {
                    return const CircularProgressIndicator();
                  }

                  if (reviewState is GetUserReviewsSuccess) {
                    final hasRated = reviewState.reviewsList.any(
                      (r) => r.orderId == orderData.id,
                    );
                    if (hasRated) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        title: local.rateClient, // <-- هنا
                        ontap: () => _showRatingBottomSheet(context, orderData),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AdminMessageCard(message: adminMessage),
            ),
          ],
        );
      },
    );
  }
}
