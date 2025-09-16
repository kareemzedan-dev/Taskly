import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../pdf_viewer_view.dart';

class AttachmentItemViewer extends StatelessWidget {
  final String attachmentName;
  final String attachmentPath;

  AttachmentItemViewer({
    super.key,
    required this.attachmentName,
    required this.attachmentPath,
  });

  bool get isNetwork => attachmentPath.startsWith("http");

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.all(8.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: ColorsManager.primary.withValues(alpha: .5), width: 1.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                attachmentName,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_red_eye, color: ColorsManager.primary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => PdfViewerView(
                          pdfPath: attachmentPath,
                          isNetwork: true,
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
