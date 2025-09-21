import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_offers_view_model/get_offers_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/get_offers_view_model/get_offers_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/cubit/client_order_status_view_model/client_order_status_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/offers_model_bottom_sheet_content.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_action_button.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_details_bottom_sheet_content.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_header.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/order_progress_time_line.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';
import '../../cubit/client_order_status_view_model/client_order_status_states.dart';
import '../../cubit/update_offer_status_view_model/update_offer_status_view_model.dart';

int getStep(OrderStatus status) {
  switch (status) {
    case OrderStatus.Pending:
    case OrderStatus.Accepted:
      return 0;
    case OrderStatus.InProgress:
      return 1;
    case OrderStatus.Completed:
      return 2;
    default:
      return 0;
  }
}

class OrderStatesCard extends StatelessWidget {
  final OrderEntity order;
  const OrderStatesCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetOffersViewModel>(
          create: (_) => getIt<GetOffersViewModel>()..init(order.id),
        ),
        BlocProvider<ClientOrderStatusViewModel>(
          create: (_) => getIt<ClientOrderStatusViewModel>()..subscribeToOrder(order.id),
        ),
      ],
      child: Card(
        elevation: 10,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderHeader(
                  orderName: order.title,
                  orderId: order.id,
                  orderStatus: order.status.name,
                ),
                SizedBox(height: 20.h),
                OrderProgressTimeline(
                  steps: ['Created', 'Paid', 'Executing', 'Completed'],
                  currentStep: getStep(order.status),
                ),
                SizedBox(height: 26.h),
                BlocBuilder<ClientOrderStatusViewModel, OrderStatusState>(
                  builder: (context, updatedState) {
                    OrderEntity? updatedOrder;

                    if (updatedState is OrderStatusUpdated) {
                      updatedOrder = updatedState.order;
                    } else {
                      updatedOrder = order; // fallback للاستخدام الأصلي
                    }

                    return BlocBuilder<ClientOrderStatusViewModel, OrderStatusState>(
                      builder: (context, state) {
                        OrderEntity currentOrder;

                        if (state is OrderStatusUpdated) {
                          currentOrder = state.order;
                        } else {
                          currentOrder = order;
                        }

                        bool hasAcceptedOffer = false;
                        int count = 0;

                        final offersState = context.watch<GetOffersViewModel>().state;
                        if (offersState is GetOffersViewModelSuccess) {
                          count = offersState.offersCount;
                          hasAcceptedOffer = offersState.offers.any((o) => o.offerStatus == "accepted");
                        }

                        if (currentOrder.status == OrderStatus.Pending && !hasAcceptedOffer) {
                          return OrderActionButton(
                            text: "Offers You’ve Received",
                            icon: Icons.local_offer_outlined,
                            color: ColorsManager.primary,
                            count: count,
                            onTap: () {
                              final viewModel = context.read<GetOffersViewModel>();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (ctx) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(value: viewModel),
                                    BlocProvider(create: (_) => getIt<UpdateOfferStatusViewModel>()),
                                  ],
                                  child: OffersBottomSheetContent(orderId: currentOrder.id),
                                ),
                              );
                            },
                          );
                        } else {
                          return OrderActionButton(
                            text: "Paid Now ${currentOrder.budget ?? 0} SAR",
                            icon: Icons.money,
                            color: ColorsManager.primary,
                            onTap: () {},
                          );
                        }
                      },
                    );

                  },
                ),

                SizedBox(height: 10.h),
                OrderActionButton(
                  text: "View details",
                  icon: Icons.remove_red_eye_outlined,
                  color: ColorsManager.primary,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => OrderDetailsBottomSheetContent(order: order),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
