import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/helper/date_time_formatter.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/domain/entities/order_entity/order_entity.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/action_row.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/delivery_info.dart';

class FreelancerWorkCard extends StatefulWidget {
  const FreelancerWorkCard({super.key, required this.order});
  final OrderEntity order;

  @override
  State<FreelancerWorkCard> createState() => _FreelancerWorkCardState();
}

class _FreelancerWorkCardState extends State<FreelancerWorkCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 2.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderRow(
                widget.order.createdAt.toRelative(),
                isFavorite: isFavorite,
                onFavoriteTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
              SizedBox(height: 10),
              _Title(widget.order.title),
              SizedBox(height: 5),
              _CategoryChip(widget.order.category ?? "No category"),
              SizedBox(height: 16),
              _Description(widget.order.description ?? "No description"),
              SizedBox(height: 16),
              DeliveryInfo(),
              SizedBox(height: 16),
              ActionsRow(order: widget.order),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow(this.date, {required this.isFavorite, required this.onFavoriteTap});

  final String date;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Posted $date",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
        ),
        GestureDetector(
          onTap: onFavoriteTap,
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
            color: isFavorite ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}


class _Title extends StatelessWidget {
  const _Title(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 18.sp,
      ),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip(this.category);
  final String category;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 30.h,
        decoration: BoxDecoration(
          color: ColorsManager.primary.withOpacity(.5),
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Text(
            category,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description(this.description);
  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
      maxLines: 2,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }
}
