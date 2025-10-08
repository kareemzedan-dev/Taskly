import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskly/core/utils/colors_manger.dart';
import 'package:taskly/features/reviews/presentation/widgets/user_avatar.dart';

enum SenderType { client, freelancer, admin }
enum MessageType { text, audio, file }

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final SenderType sender;
  final String avatarUrl;
  final MessageType type; // 👈 نوع الرسالة
  final String? fileUrl; // 👈 لو فيها فايل أو صوت

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.sender,
    required this.avatarUrl,
    this.type = MessageType.text,
    this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isClient = sender == SenderType.client;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        isClient ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isClient) ...[
            UserAvatar(imagePath: avatarUrl, radius: 16.r),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 0.7.sw),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: isClient
                    ? Colors.grey.shade300
                    : ColorsManager.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(isClient ? 0 : 16.r),
                  bottomRight: Radius.circular(isClient ? 16.r : 0),
                ),
              ),
              child: Column(
                crossAxisAlignment: isClient
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  _buildMessageContent(context),
                  SizedBox(height: 6.h),
                  Text(
                    time,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: !isClient
                          ? Colors.white
                          : ColorsManager.black,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isClient) ...[
            SizedBox(width: 8.w),
            UserAvatar(imagePath: avatarUrl, radius: 16.r)
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (type) {
      case MessageType.text:
        return Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: sender == SenderType.client
                ? ColorsManager.black
                : ColorsManager.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        );

      case MessageType.audio:
        return _AudioMessageBubble(fileUrl: fileUrl ?? '');

      case MessageType.file:
        return _FileMessageBubble(fileUrl: fileUrl ?? '');

      default:
        return const SizedBox();
    }
  }
}

// 👇 ويدجت بسيطة للصوت
class _AudioMessageBubble extends StatelessWidget {
  final String fileUrl;
  const _AudioMessageBubble({required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.play_circle_fill, color: Colors.white),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            "Voice message",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// 👇 ويدجت بسيطة للملفات / الصور
class _FileMessageBubble extends StatelessWidget {
  final String fileUrl;
  const _FileMessageBubble({required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    final isImage = fileUrl.endsWith(".jpg") ||
        fileUrl.endsWith(".png") ||
        fileUrl.endsWith(".jpeg");

    if (isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(fileUrl, height: 150.h, fit: BoxFit.cover),
      );
    }

    return Row(
      children: [
        const Icon(Icons.attach_file, color: Colors.white),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            fileUrl.split('/').last,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
