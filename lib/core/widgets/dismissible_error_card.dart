import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DismissibleErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const DismissibleErrorCard({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();

    return Card(
      color: Colors.red.shade100,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
            ),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
void showTemporaryError(BuildContext context, String message, {int durationSeconds = 3}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 100,  
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: DismissibleErrorCard(
          message: message,
          onDismiss: () {
            entry.remove();
          },
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(Duration(seconds: durationSeconds), () {
    entry.remove();
  });
}
