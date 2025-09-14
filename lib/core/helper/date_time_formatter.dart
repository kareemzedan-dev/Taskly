extension DateTimeRelative on DateTime {
  String toRelative() {
    final now = DateTime.now().toUtc(); // استخدام التوقيت العالمي
    final thisUtc = toUtc(); // تحويل التاريخ إلى UTC
    
    final difference = now.difference(thisUtc);
    
    if (difference.isNegative) {
      // الوقت في المستقبل
      final future = difference.abs();
      if (future.inSeconds < 60) {
        return "now";
      } else if (future.inMinutes < 60) {
        return "in ${future.inMinutes} ${future.inMinutes == 1 ? 'minute' : 'minutes'}";
      } else if (future.inHours < 24) {
        return "in ${future.inHours} ${future.inHours == 1 ? 'hour' : 'hours'}";
      } else {
        return "in ${future.inDays} ${future.inDays == 1 ? 'day' : 'days'}";
      }
    } else {
      // الوقت في الماضي
      if (difference.inSeconds < 60) {
        return "just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
      } else {
        return "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
      }
    }
  }
}DateTime parseSupabaseDate(String dateString) {
  // إزالة الجزء الزائد :00 من النهاية إذا وجد
  if (dateString.contains('+00:00')) {
    dateString = dateString.replaceFirst('+00:00', '+00');
  }
  return DateTime.parse(dateString);
}