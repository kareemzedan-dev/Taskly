DateTime? calculateDeadline(String text, String timeUnit) {
  if (text.isEmpty) return null;

  final value = int.tryParse(text);
  if (value == null) return null;

  switch (timeUnit) {
    case "Hours":
      return DateTime.now().add(Duration(hours: value));
    case "Days":
      return DateTime.now().add(Duration(days: value));
    case "Weeks":
      return DateTime.now().add(Duration(days: value * 7));
    default:
      return null;
  }
}
