
extension RelativeTime on DateTime {
  String toRelative() {
    final now = DateTime.now();
    final difference = this.difference(now);

    bool isPast = difference.isNegative;

    int totalSeconds = difference.inSeconds.abs();

    final days = totalSeconds ~/ (24 * 3600);
    totalSeconds -= days * 24 * 3600;

    final hours = totalSeconds ~/ 3600;
    totalSeconds -= hours * 3600;

    final minutes = totalSeconds ~/ 60;
    totalSeconds -= minutes * 60;

    final seconds = totalSeconds;

    String suffix = isPast ? " ago" : " left";

    if (days > 0) {
      String result = "$days day${days > 1 ? 's' : ''}";
      if (hours > 0) {
        result += " $hours hour${hours > 1 ? 's' : ''}";
      }
      return result + suffix;
    } else if (hours > 0) {
      String result = "$hours hour${hours > 1 ? 's' : ''}";
      if (minutes > 0) {
        result += " $minutes minute${minutes > 1 ? 's' : ''}";
      }
      return result + suffix;
    } else if (minutes > 0) {
      return "$minutes minute${minutes > 1 ? 's' : ''}$suffix";
    } else {
      return "just now";
    }
  }
}