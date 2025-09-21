import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/freelancers_view_model/freelancers_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/freelancers_view_model/freelancers_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/freelancer_info_card_for_hire.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/reviews_card.dart';

import '../../cubit/place_order_view_model/place_order_view_model.dart';

class FreelancerInfoListView extends StatefulWidget {
    FreelancerInfoListView({super.key, required this.selectedId});
  String? selectedId;
  @override
  State<FreelancerInfoListView> createState() => _FreelancerInfoListViewState();
}

class _FreelancerInfoListViewState extends State<FreelancerInfoListView> {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FreelancersViewModel, FreelancersViewModelStates>(
      builder: (context, state) {
        if (state is FreelancersViewModelStatesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FreelancersViewModelStatesSuccess) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.freelancers.length,
            itemBuilder: (context, index) {
              final freelancer = state.freelancers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FreelancerInfoCardForHire(
                  onReviewsTap: (){
                    showModalBottomSheet(context: context, builder: (context) {
                      return ReviewsCard();
                    },);
                  },
                  freelancer: freelancer,
                  isSelected: freelancer.id == widget.selectedId,
                  onTap: () {

                    setState(() {
                      widget.selectedId = freelancer.id;
                      context.read<PlaceOrderViewModel>().setFreelancer(freelancer.id);
                    });
                    debugPrint("Selected Freelancer ID: ${freelancer.id}");
                  },
                ),
              );
            },
          );
        } else if (state is FreelancersViewModelStatesError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }
}
