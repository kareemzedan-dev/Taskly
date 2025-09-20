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
    if (this >= 7 * 24 * 60) {
      double weeks = this / (7 * 24 * 60);
      return weeks % 1 == 0
          ? "${weeks.toInt()} ${weeks.toInt() == 1 ? 'Week' : 'Weeks'}"
          : "${weeks.toStringAsFixed(1)} Weeks";
    } else if (this >= 24 * 60) {
      double days = this / (24 * 60);
      return days % 1 == 0
          ? "${days.toInt()} ${days.toInt() == 1 ? 'Day' : 'Days'}"
          : "${days.toStringAsFixed(1)} Days";
    } else if (this >= 60) {
      double hours = this / 60;
      return hours % 1 == 0
          ? "${hours.toInt()} ${hours.toInt() == 1 ? 'Hour' : 'Hours'}"
          : "${hours.toStringAsFixed(1)} Hours";
    } else {
      return "$this ${this == 1 ? 'Minute' : 'Minutes'}";
    }
  }
}
