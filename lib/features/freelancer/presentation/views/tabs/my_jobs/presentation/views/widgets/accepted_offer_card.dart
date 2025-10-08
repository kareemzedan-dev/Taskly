import 'package:flutter/material.dart';
import '../../../../../../../../../config/routes/routes_manager.dart';
import '../../../../../../../../../features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import '../../../../find_work/presentation/views/widgets/action_row.dart';
import 'base_offer_card.dart';
import '../../../../../../../../messages/presentation/widgets/admin_message_card.dart';

class AcceptedOfferCard extends StatelessWidget {
  final OfferEntity offerEntity;

  const AcceptedOfferCard({super.key, required this.offerEntity});

  @override
  Widget build(BuildContext context) {
    return BaseOfferCard(
      offerEntity: offerEntity,
      bottomWidget: ActionsRow(
        actions: [
          ActionItem(
            title: "View details",
            icon: Icons.remove_red_eye_outlined,
            onTap: () {
              Navigator.pushNamed(
                context,
                RoutesManager.offerDetailsView,
                arguments: {
                  'orderId': offerEntity.orderId,
                },
              );
            },
          ),
        ],
      ),
      topWidget: const AdminMessageCard(
        message:
            "Please check the order status in the Messages section and contact the client if needed.",
      ),
    );
  }
}
