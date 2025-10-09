import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import '../../view_model/get_offers_view_model/get_offers_view_model.dart';

class OffersFilters extends StatefulWidget {
  final List<String> filters;

  const OffersFilters({super.key, required this.filters});

  @override
  State<OffersFilters> createState() => _OffersFiltersState();
}

class _OffersFiltersState extends State<OffersFilters> {
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    final offersViewModel = context.read<GetOffersViewModel>();

    return Row(
      children: [
        Text(
          "Filter by:",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 10.w),
        ...widget.filters.map(
              (filter) => Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: selectedFilter == filter,
              backgroundColor: ColorsManager.primary.withOpacity(.5),
              selectedColor: ColorsManager.primary.withOpacity(0.7),
              labelStyle: const TextStyle(color: Colors.white),
              onSelected: (bool selected) {
                setState(() {
                  selectedFilter = selected ? filter : null;
                });

                // فرز العروض حسب الفلتر المختار
                if (filter == "Price") {
                  offersViewModel.sortOffers(OfferSortBy.price);
                } else if (filter == "Delivery") {
                  offersViewModel.sortOffers(OfferSortBy.delivery);
                } else if (filter == "Rating") {
                  offersViewModel.sortOffers(OfferSortBy.rating);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
