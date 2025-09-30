
 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/action_button.dart';

import '../../../../../../../../../config/routes/routes_manager.dart';
import '../../view_model/update_offer_status_view_model/update_offer_status_states.dart';
import '../../view_model/update_offer_status_view_model/update_offer_status_view_model.dart';

class OfferActions extends StatelessWidget {
  const OfferActions({super.key, required this.offerId, required this.onAcceptOffer});
  final String offerId;
  final void Function() onAcceptOffer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionButton(
            text: "Start Chat",
            icon: Icons.chat,
            color: Colors.blue,
            filled: false,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ActionButton(
            text: "Accept Offer",
            icon: Icons.check,
            color: Colors.green,
            filled: true,
           onTap: onAcceptOffer,
          ),
        ),
      ],
    );
  }
}
