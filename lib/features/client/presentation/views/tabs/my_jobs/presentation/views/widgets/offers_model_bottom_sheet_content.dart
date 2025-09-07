import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/offer_card.dart';
import 'package:taskly/features/client/presentation/views/tabs/my_jobs/presentation/views/widgets/offer_header.dart';

class OffersBottomSheetContent extends StatelessWidget {
  OffersBottomSheetContent({super.key});

  final filters = ["Price", "Delivery", "Rating"];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: double.infinity,
      child: Column(
        children: [
          OffersHeader(
            title: "Offers Received",
            count: 1,
            filters: filters,
          ),

      
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  OfferCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  