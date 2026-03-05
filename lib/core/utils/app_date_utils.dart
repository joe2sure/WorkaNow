import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatTime(DateTime dt) => DateFormat('hh:mm a').format(dt);
  static String formatDate(DateTime dt) => DateFormat('EEE, MMM d yyyy').format(dt);
  static String formatShortDate(DateTime dt) => DateFormat('MMM d').format(dt);
  static String formatMonth(DateTime dt) => DateFormat('MMMM yyyy').format(dt);

  static String formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h == 0) return '${m}m';
    return '${h}h ${m}m';
  }

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isWorkingHours(DateTime dt) {
    return dt.hour >= 8 && dt.hour < 18;
  }

  static int workingDaysInMonth(DateTime month) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    int workdays = 0;
    for (int i = 1; i <= daysInMonth; i++) {
      final day = DateTime(month.year, month.month, i);
      if (day.weekday != DateTime.saturday && day.weekday != DateTime.sunday) {
        workdays++;
      }
    }
    return workdays;
  }
}