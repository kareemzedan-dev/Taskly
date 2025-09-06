import 'package:flutter/material.dart';
import 'package:taskly/core/utils/routes_manager.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/custom_action_container.dart';

class ActionsRow extends StatelessWidget {
  const ActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomActionContainer(
          title: "View details",
          icon: Icons.remove_red_eye_outlined,
          onTap: () => Navigator.pushNamed(
            context,
            RoutesManager.jobDetailsView,
          ),
        ),
          CustomActionContainer(
            onTap: () => Navigator.pushNamed(context, RoutesManager.sendOfferView),
          title: "Send offers",
          icon: Icons.send,
          isOffer: true,
        ),
      ],
    );
  }
}
