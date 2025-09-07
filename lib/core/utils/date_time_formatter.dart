 
extension DateTimeRelative on DateTime {
  String toRelative() {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.isNegative) {
      final past = difference.abs();
      if (past.inMinutes < 60) {
        return "${past.inMinutes} minutes ago";
      } else if (past.inHours < 24) {
        return "${past.inHours} hours ago";
      } else {
        return "${past.inDays} days ago";
      }
    } else {
      if (difference.inMinutes < 60) {
        return "in ${difference.inMinutes} minutes";
      } else if (difference.inHours < 24) {
        return "in ${difference.inHours} hours";
      } else {
        return "in ${difference.inDays} days";
      }
    }
  }
}
