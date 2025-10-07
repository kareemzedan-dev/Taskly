import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../../../core/utils/assets_manager.dart';

class UserAvatar extends StatelessWidget {
  final String? imagePath;
  final double? radius;

  const UserAvatar({super.key, this.imagePath, this.radius = 30});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 30.r,
      backgroundImage: (imagePath != null && imagePath!.isNotEmpty)
          ? (imagePath!.startsWith('http')
          ? NetworkImage(imagePath!)
          : FileImage(File(imagePath!)) as ImageProvider)
          : const AssetImage(Assets.assetsUserAvatar)  as ImageProvider,
    );
  }
}
