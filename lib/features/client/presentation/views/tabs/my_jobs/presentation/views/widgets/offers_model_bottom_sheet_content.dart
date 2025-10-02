import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/config/routes/routes_manager.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/offer_card.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/offer_header.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/get_offers_view_model/get_offers_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/get_offers_view_model/get_offers_view_model_states.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:taskly/features/freelancer/presentation/cubit/fetch_order_details_view_model/fetch_order_details_view_model.dart';

import '../../../../../../../../../core/components/dismissible_error_card.dart';
import '../../../../../../../../../core/utils/assets_manager.dart';
import '../../../../../../../../shared/domain/entities/order_entity/order_entity.dart';
import '../../../../../client_home_view.dart';
import '../../view_model/update_offer_status_view_model/update_offer_status_states.dart';
import '../../view_model/update_offer_status_view_model/update_offer_status_view_model.dart';

class OffersBottomSheetContent extends StatelessWidget {
  final String orderId;
  final OrderEntity order;

  const OffersBottomSheetContent(
      {super.key, required this.orderId, required this.order});

  @override
  Widget build(BuildContext context) {
    final offersViewModel = context.read<GetOffersViewModel>();

    return BlocConsumer<UpdateOfferStatusViewModel, UpdateOfferStatusStates>(
      listener: (context, state) {
        if (state is UpdateOfferStatusLoadingState) {
          showTemporaryMessage(context, "Loading...", MessageType.success);
        } else if (state is UpdateOfferStatusErrorState) {
          showTemporaryMessage(context, "Error", MessageType.error);
        } else if (state is UpdateOfferStatusSuccessState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ClientHomeView(initialIndex: 1),
            ),
            (route) => false,
          );
          //  Navigator.pop(context);
          showTemporaryMessage(
              context, "Offer Accepted Successfully", MessageType.success);

          offersViewModel.getOffers(orderId);
        }
      },
      builder: (context, updateState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: BlocBuilder<GetOffersViewModel, GetOffersViewModelStates>(
            builder: (context, state) {
              if (state is GetOffersViewModelLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetOffersViewModelError) {
                return Center(child: Text("Error: ${state.message}"));
              } else if (state is GetOffersViewModelSuccess) {
                final offers = state.offers;
                return Column(
                  children: [
                    OffersHeader(
                      title: "Offers Received",
                      count: offers.length,
                      filters: ["Price", "Delivery", "Rating"],
                    ),
                    if (offers.isNotEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: offers
                                .map((offer) => OfferCard(
                                      order: order,
                                      offer: offer,
                                      onAcceptOffer: () {
                                        print(
                                            "Calling updateOfferStatus with ${offer.id}");

                                        context
                                            .read<UpdateOfferStatusViewModel>()
                                            .acceptOfferAndRejectOthers(
                                              offer.orderId,
                                              offer.id,
                                            );
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    if (offers.isEmpty)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Assets.assetsImagesempty,
                              height: 200.h,
                              width: 200.w,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "No Offers yet",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }
              return Text(
                "No Offers",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.grey),
              );
            },
          ),
        );
      },
    );
  }
}
