import 'package:flutter/material.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/freelancer_info_card_for_hire.dart';

class FreelancerInfoListView extends StatelessWidget {
  const FreelancerInfoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric( vertical: 8.0),
          child: const FreelancerInfoCardForHire(),
        );
      },
    );
  }
}