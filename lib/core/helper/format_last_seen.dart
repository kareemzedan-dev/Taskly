import 'package:intl/intl.dart';

String formatLastSeen({required bool isOnline, DateTime? lastSeen}) {
  if (isOnline) return "Online";

  if (lastSeen == null) return "Last seen: Unknown";

  final now = DateTime.now();
  final difference = now.difference(lastSeen);

  // لو النهاردة
  if (difference.inDays == 0) {
    final formattedTime = DateFormat('hh:mm a').format(lastSeen);
    return "Last seen today at $formattedTime";
  }

  // لو امبارح
  if (difference.inDays == 1) {
    final formattedTime = DateFormat('hh:mm a').format(lastSeen);
    return "Last seen yesterday at $formattedTime";
  }

  // لو خلال أسبوع
  if (difference.inDays < 7) {
    return "Last seen ${difference.inDays} days ago";
  }

  // لو من أكتر من أسبوع → نعرض التاريخ كامل
  final formattedDate = DateFormat('MMM d, yyyy').format(lastSeen);
  return "Last seen on $formattedDate";
}
