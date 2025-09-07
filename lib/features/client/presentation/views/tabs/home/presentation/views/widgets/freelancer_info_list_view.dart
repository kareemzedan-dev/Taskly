import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/freelancers_view_model/freelancers_view_model.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/cubit/freelancers_view_model/freelancers_view_model_states.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/freelancer_info_card_for_hire.dart';

class FreelancerInfoListView extends StatefulWidget {
  const FreelancerInfoListView({super.key});

  @override
  State<FreelancerInfoListView> createState() => _FreelancerInfoListViewState();
}

class _FreelancerInfoListViewState extends State<FreelancerInfoListView> {
  String? selectedId;

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
                  freelancer: freelancer,
                  isSelected: freelancer.id == selectedId,
                  onTap: () {
                    setState(() {
                      selectedId = freelancer.id;
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
