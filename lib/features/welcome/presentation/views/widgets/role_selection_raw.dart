import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/assets_manager.dart';
import 'package:taskly/features/welcome/presentation/views/widgets/role_box.dart';
import 'package:taskly/l10n/app_localizations.dart';

class RoleSelectionRow extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onRoleSelected;

  const RoleSelectionRow({
    super.key,
    required this.selectedIndex,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RoleBox(
            image: Assets.assetsImagesFreelancer,
            title: AppLocalizations.of(context)!.freelancerTitle,
            subtitle: AppLocalizations.of(context)!.freelancerSubtitle,
            isSelected: selectedIndex == 0,
            onTap: () => onRoleSelected(0),
          ),
          RoleBox(
            image: Assets.assetsImagesClient,
            title: AppLocalizations.of(context)!.clientTitle,
            subtitle: AppLocalizations.of(context)!.clientSubtitle,
            isSelected: selectedIndex == 1,
            onTap: () => onRoleSelected(1),
          ),
        ],
      ),
    );
  }
}
