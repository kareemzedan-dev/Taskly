import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerView extends StatelessWidget {
  final String pdfPath;
  final bool isNetwork;

  const PdfViewerView({
    super.key,
    required this.pdfPath,
    required this.isNetwork,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        leading: IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PDF Viewer',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
          ),
        ),
      ),
      // استخدم Expanded عشان ياخد كل المساحة المتاحة
      body: SafeArea(
        child: SizedBox.expand(
          child: isNetwork
              ? SfPdfViewer.network(pdfPath)
              : SfPdfViewer.file(File(pdfPath)),
        ),
      ),
    );
  }
}
