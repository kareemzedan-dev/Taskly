import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/core/di/di.dart';
import 'package:taskly/features/freelancer/domain/entities/offer_entity/offer_entity.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/my_jobs/presentation/views/widgets/pending_offer_card.dart';
import 'package:taskly/features/profile/presentation/manager/profile_view_model/profile_view_model_states.dart';

import '../../../../../../../../profile/domain/entities/user_info_entity/user_info_entity.dart';
import '../../../../../../../../profile/presentation/manager/profile_view_model/profile_view_model.dart';

class PendingOffersListView extends StatelessWidget {
    PendingOffersListView({super.key,required this.offer,  this.isPending= false });
List<OfferEntity> offer;
bool isPending  ;

  @override
  Widget build(BuildContext context) {
    return  ListView.separated(
      itemCount: offer.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return Divider(thickness: 1, color: Colors.grey,);
      },

      itemBuilder: (context, index) {

              return Padding(
                padding: const EdgeInsets.symmetric(vertical:  8.0),
                child:   PendingOfferCard(offerEntity: offer[index] ,isPending: isPending),
              );


      }
    );
  }
}
