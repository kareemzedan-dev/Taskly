import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/core/cache/shared_preferences.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/core/utils/strings_manager.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/view_model/get_offers_view_model/get_offers_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/empty_state_animation.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:taskly/features/freelancer/presentation/cubit/get_freelancer_offers_view_model/get_freelancer_offers_states.dart';
import 'package:taskly/features/freelancer/presentation/cubit/get_freelancer_offers_view_model/get_freelancer_offers_view_model.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/my_jobs/presentation/views/widgets/tracking_offers_list_view.dart';
import '../../../../../../../../../core/helper/notifications_helper.dart';

class MyJobsTabViewBody extends StatefulWidget {
  const MyJobsTabViewBody({super.key});

  @override
  State<MyJobsTabViewBody> createState() => _MyJobsTabViewBodyState();
}

class _MyJobsTabViewBodyState extends State<MyJobsTabViewBody> {
  late final GetFreelancerOffersViewModel viewModel;
  StreamSubscription<(OfferEntity, String)>? _subscription;

  final freelancerId = SharedPrefHelper.getString(StringsManager.idKey)!;

  @override
  void initState() {
    super.initState();
    viewModel = getIt<GetFreelancerOffersViewModel>();

    // أول تحميل للـ offers
    viewModel.getFreelancerOffers(freelancerId, null);

    // الاشتراك في الـ stream
    _subscription = viewModel.subscribeToOffers(freelancerId).listen((event) {
      final (offer, action) = event;

      // نعمل refresh للـ offers
      viewModel.getFreelancerOffers(freelancerId, null);

      // Notifications
      if (offer.offerStatus == 'accepted') {
        NotificationHelper.showNotification(context, "Your offer got accepted!");
      } else if (offer.offerStatus == 'rejected') {
        NotificationHelper.showNotification(context, "Your offer was rejected!");
      } else if (offer.offerStatus == 'pending') {
        NotificationHelper.showNotification(context, "New pending offer!");
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        // Pending tab
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<GetFreelancerOffersViewModel,
              GetFreelancerOffersStates>(
            bloc: viewModel,
            builder: (context, state) {
              if (state is GetFreelancerOffersLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GetFreelancerOffersErrorState) {
                return Center(child: Text(state.message));
              }
              if (state is GetFreelancerOffersSuccessState) {
                final pendingOffers = state.offers
                    .where((o) => o.offerStatus == "pending")
                    .toList();

                if (pendingOffers.isEmpty) {
                  return const EmptyStateAnimation(
                    animationPath: 'assets/lotties/Loading.json',
                    message: 'No pending offers',
                  );
                }
                return TrackingOffersListView(
                  offer: pendingOffers,
                  isPending: true,
                );
              }
              return const Center(child: Text("No offers"));
            },
          ),
        ),

        // Accepted tab
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<GetFreelancerOffersViewModel,
              GetFreelancerOffersStates>(
            bloc: viewModel,
            builder: (context, state) {
              if (state is GetFreelancerOffersLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GetFreelancerOffersErrorState) {
                return Center(child: Text(state.message));
              }
              if (state is GetFreelancerOffersSuccessState) {
                final acceptedOffers = state.offers
                    .where((o) => o.offerStatus == "accepted")
                    .toList();

                if (acceptedOffers.isEmpty) {
                  return const EmptyStateAnimation(
                    animationPath: 'assets/lotties/Progress.json',
                    message: 'No accepted offers',
                  );
                }
                return TrackingOffersListView(offer: acceptedOffers);
              }
              return const Center(child: Text("No offers"));
            },
          ),
        ),

        // Completed tab
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<GetFreelancerOffersViewModel,
              GetFreelancerOffersStates>(
            bloc: viewModel,
            builder: (context, state) {
              if (state is GetFreelancerOffersLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GetFreelancerOffersErrorState) {
                return Center(child: Text(state.message));
              }
              if (state is GetFreelancerOffersSuccessState) {
                final completedOffers = state.offers
                    .where((o) => o.offerStatus == "completed")
                    .toList();

                if (completedOffers.isEmpty) {
                  return const EmptyStateAnimation(
                    animationPath: 'assets/lotties/Success.json',
                    message: 'No completed projects yet',
                  );
                }
                return TrackingOffersListView(offer: completedOffers);
              }
              return const Center(child: Text("No offers"));
            },
          ),
        ),

        // Rejected tab
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<GetFreelancerOffersViewModel,
              GetFreelancerOffersStates>(
            bloc: viewModel,
            builder: (context, state) {
              if (state is GetFreelancerOffersLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GetFreelancerOffersErrorState) {
                return Center(child: Text(state.message));
              }
              if (state is GetFreelancerOffersSuccessState) {
                final rejectedOffers = state.offers
                    .where((o) => o.offerStatus == "rejected")
                    .toList();

                if (rejectedOffers.isEmpty) {
                  return const EmptyStateAnimation(
                    animationPath: 'assets/lotties/cancelled.json',
                    message: 'No rejected offers',
                  );
                }
                return TrackingOffersListView(offer: rejectedOffers);
              }
              return const Center(child: Text("No offers"));
            },
          ),
        ),
      ],
    );
  }
}
