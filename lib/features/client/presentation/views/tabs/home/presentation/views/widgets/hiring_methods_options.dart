import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskly/features/client/presentation/views/tabs/home/presentation/views/widgets/hire_method_card.dart';

class HiringMethodsOptions extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const HiringMethodsOptions({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<HiringMethodsOptions> createState() => _HiringMethodsOptionsState();
}

class _HiringMethodsOptionsState extends State<HiringMethodsOptions> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: HireMethodCard(
              icon: Icons.language,
              title: "Public Posting",
              subtitle:
                  "Post your request publicly and receive multiple proposals",
              isSelected: widget.selectedIndex == 0,
              onTap: () {
                widget.onChanged(0);
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: HireMethodCard(
              icon: FontAwesomeIcons.bullseye,
              title: "Hire Specific Freelancer",
              subtitle:
                  "Send your request directly to a specific freelancer as a private offer",
              isSelected: widget.selectedIndex == 1,
              onTap: () {
                widget.onChanged(1);
              },
              badge: "Private",
            ),
          ),
        ],
      ),
    );
  }
}
