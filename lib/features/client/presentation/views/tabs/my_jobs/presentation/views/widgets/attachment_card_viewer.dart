import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'package:taskly/core/components/dismissible_error_card.dart';
import 'package:taskly/core/utils/colors_manger.dart';

import '../pdf_viewer_view.dart';

class AttachmentItemViewer extends StatelessWidget {
  final String attachmentName;
  final String attachmentPath;
  final bool isFreelancer;

  const AttachmentItemViewer({
    super.key,
    required this.attachmentName,
    required this.attachmentPath,
    required this.isFreelancer,
  });

  bool get isNetwork => attachmentPath.startsWith("http");

  Future<void> downloadFile(BuildContext context) async {
    try {
      final dio = Dio();

      final dir = await getApplicationDocumentsDirectory();

      final savePath = "${dir.path}/$attachmentName";

 showTemporaryMessage(context, 'Downloading...', MessageType.success);

      await dio.download(attachmentPath, savePath);

     showTemporaryMessage(context, 'Downloaded to $savePath', MessageType.success);


      await  OpenFile.open(savePath);
    } catch (e) {
 showTemporaryMessage(context, 'Download failed: $e', MessageType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.all(8.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: ColorsManager.primary.withValues(alpha: .5),
            width: 1.w,
          ),
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_red_eye, color: ColorsManager.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfViewerView(
                          pdfPath: attachmentPath,
                          isNetwork: true,
                        ),
                      ),
                    );
                  },
                ),
                if (isFreelancer)
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.green),
                    onPressed: () => downloadFile(context),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
