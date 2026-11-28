// Small helpers that turn numbers and dates into the text the screens show.
// Both the customer side and the manager side use these, so a price or a
// date always looks the same everywhere.
class AppFormat {
  static List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static List<String> fullDayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static List<String> fullMonthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // 300000 -> "Rs 3,00,000" (Pakistani style: last 3 digits, then groups of 2)
  static String rupees(int amount) {
    String digits = amount.toString();
    if (digits.length <= 3) {
      return 'Rs $digits';
    }

    final String last3 = digits.substring(digits.length - 3);
    String rest = digits.substring(0, digits.length - 3);
    String groups = '';

    while (rest.length > 2) {
      groups = ',${rest.substring(rest.length - 2)}$groups';
      rest = rest.substring(0, rest.length - 2);
    }
    return 'Rs $rest$groups,$last3';
  }

  // "Sat 19 Dec"
  static String shortDate(DateTime d) {
    return '${dayNames[d.weekday - 1]} ${d.day} ${monthNames[d.month - 1]}';
  }

  // "Sat 19 Dec 2026"
  static String dateWithYear(DateTime d) {
    return '${shortDate(d)} ${d.year}';
  }

  // "19 Dec 2026"
  static String dayMonthYear(DateTime d) {
    return '${d.day} ${monthNames[d.month - 1]} ${d.year}';
  }

  // "Saturday, 19 December 2026"
  static String fullDate(DateTime d) {
    return '${fullDayNames[d.weekday - 1]}, ${d.day} ${fullMonthNames[d.month - 1]} ${d.year}';
  }

  // "9:14 pm"  (padLeft(2, '0') turns 5 into "05")
  static String time(DateTime d) {
    int hour = d.hour % 12;
    if (hour == 0) {
      hour = 12;
    }
    final String minute = d.minute.toString().padLeft(2, '0');
    final String amPm = d.hour < 12 ? 'am' : 'pm';
    return '$hour:$minute $amPm';
  }

  // "Mon 16 Nov, 9:14 pm"
  static String dateAndTime(DateTime d) {
    return '${shortDate(d)}, ${time(d)}';
  }

  // Chat and list times: "4:32 pm" for today, "26 Nov" for older days
  static String shortTime(DateTime d) {
    if (isSameDay(d, DateTime.now())) {
      return time(d);
    }
    return '${d.day} ${monthNames[d.month - 1]}';
  }

  // Under a chat message: "4:32 pm" for today, "Mon 26 Nov, 4:32 pm" before
  static String messageTime(DateTime d) {
    if (isSameDay(d, DateTime.now())) {
      return time(d);
    }
    return dateAndTime(d);
  }

  // true if both dates are on the same day (the time does not matter)
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Today at 00:00, so dates can be compared day by day
  static DateTime today() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // "Ali Raza" -> "AR"  (the same idea as getInitials in the weather app)
  static String initials(String name) {
    final List<String> parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }
}
