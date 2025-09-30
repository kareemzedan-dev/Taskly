import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/helper/date_time_formatter.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/action_row.dart';
import 'package:taskly/features/freelancer/presentation/views/tabs/find_work/presentation/views/widgets/delivery_info.dart';
import 'package:taskly/features/shared/domain/entities/order_entity/order_entity.dart';

import '../../../../../../../../../config/routes/routes_manager.dart';

class FreelancerWorkCard extends StatefulWidget {
  const FreelancerWorkCard({super.key, required this.order});
  final OrderEntity order;

  @override
  State<FreelancerWorkCard> createState() => _FreelancerWorkCardState();
}

extension RelativeTime on DateTime {
  String toRelative() {
    final now = DateTime.now();
    final difference = this.difference(now);

    bool isPast = difference.isNegative;

    int totalSeconds = difference.inSeconds.abs();

    final days = totalSeconds ~/ (24 * 3600);
    totalSeconds -= days * 24 * 3600;

    final hours = totalSeconds ~/ 3600;
    totalSeconds -= hours * 3600;

    final minutes = totalSeconds ~/ 60;
    totalSeconds -= minutes * 60;

    final seconds = totalSeconds;

    String suffix = isPast ? " ago" : " left";

    if (days > 0) {
      String result = "$days day${days > 1 ? 's' : ''}";
      if (hours > 0) {
        result += " $hours hour${hours > 1 ? 's' : ''}";
      }
      return result + suffix;
    } else if (hours > 0) {
      String result = "$hours hour${hours > 1 ? 's' : ''}";
      if (minutes > 0) {
        result += " $minutes minute${minutes > 1 ? 's' : ''}";
      }
      return result + suffix;
    } else if (minutes > 0) {
      return "$minutes minute${minutes > 1 ? 's' : ''}$suffix";
    } else {
      return "just now";
    }
  }
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
              HeaderRow(
                widget.order.createdAt.toTimeAgo(),
                isFavorite: isFavorite,
                onFavoriteTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
              SizedBox(height: 10),
              Title(widget.order.title),
              SizedBox(height: 5),
              CategoryChip(widget.order.category ?? "No category"),
              SizedBox(height: 16),
              Description(widget.order.description ?? "No description"),
              SizedBox(height: 16),
              DeliveryInfo(deliveryTime: widget.order.deadline!.toRelative()),
              SizedBox(height: 16),
              ActionsRow(
                order: widget.order,
                actions: [
                  ActionItem(
                    title: "View details",
                    icon: Icons.remove_red_eye_outlined,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesManager.jobDetailsView,
                        arguments:  widget.order,
                      );
                    },
                  ),
                  ActionItem(
                    title: "Send offers",
                    icon: Icons.send,
                    isOffer: true,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesManager.sendOfferView,
                        arguments:  widget.order,
                      );
                    },
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}

class HeaderRow extends StatelessWidget {
  const HeaderRow(
    this.date, {
      this.isFavorite = false,
      this.onFavoriteTap,
  });

  final String date;
  final bool isFavorite;
  final VoidCallback ?onFavoriteTap;

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

class Title extends StatelessWidget {
  const Title(this.title);
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

class CategoryChip extends StatelessWidget {
  const CategoryChip(this.category);
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

class Description extends StatelessWidget {
  const Description(this.description);
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
