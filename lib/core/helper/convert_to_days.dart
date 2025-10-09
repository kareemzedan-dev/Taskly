int convertToMinutes(int value, String unit) {
  switch (unit) {
    case "Hours":
      return value * 60; 
    case "Days":
      return value * 24 * 60;  
    case "Weeks":
      return value * 7 * 24 * 60;  
    default:
      return value;
  }
}
extension FormatMinutesExtension on int {
  String formatMinutes() {
    int minutes = this;

    if (minutes >= 7 * 24 * 60) {
      int weeks = minutes ~/ (7 * 24 * 60);
      int remainingMinutes = minutes % (7 * 24 * 60);
      int days = remainingMinutes ~/ (24 * 60);

      if (days > 0) {
        return "$weeks ${weeks == 1 ? 'Week' : 'Weeks'} $days ${days == 1 ? 'Day' : 'Days'}";
      } else {
        return "$weeks ${weeks == 1 ? 'Week' : 'Weeks'}";
      }
    } else if (minutes >= 24 * 60) {
      int days = minutes ~/ (24 * 60);
      int remainingMinutes = minutes % (24 * 60);
      int hours = remainingMinutes ~/ 60;

      if (hours > 0) {
        return "$days ${days == 1 ? 'Day' : 'Days'} $hours ${hours == 1 ? 'Hour' : 'Hours'}";
      } else {
        return "$days ${days == 1 ? 'Day' : 'Days'}";
      }
    } else if (minutes >= 60) {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;

      if (remainingMinutes > 0) {
        return "$hours ${hours == 1 ? 'Hour' : 'Hours'} $remainingMinutes ${remainingMinutes == 1 ? 'Minute' : 'Minutes'}";
      } else {
        return "$hours ${hours == 1 ? 'Hour' : 'Hours'}";
      }
    } else {
      return "$minutes ${minutes == 1 ? 'Minute' : 'Minutes'}";
    }
  }
}
