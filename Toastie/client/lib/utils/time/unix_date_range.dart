class UnixDateRange {
  UnixDateRange({required this.startTime, required this.endTime});
  final int startTime;
  final int endTime;
}

UnixDateRange convertDayToUnixDateRange({required DateTime date}) {
  DateTime startOfDay = DateTime(date.year, date.month, date.day);
  int startOfDayUnix = startOfDay.millisecondsSinceEpoch ~/ 1000;
  DateTime endOfDay =
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999, 999);
  int endOfDayUnix = endOfDay.millisecondsSinceEpoch ~/ 1000;

  return UnixDateRange(
    startTime: startOfDayUnix,
    endTime: endOfDayUnix,
  );
}

UnixDateRange convertToUnixWeekRange(DateTime date) {
  // Get start of week (Monday)
  int daysToSubtract = (date.weekday - 1) % 7;
  DateTime startOfWeek = DateTime(date.year, date.month, date.day)
      .subtract(Duration(days: daysToSubtract));
  int startOfWeekUnix = startOfWeek.millisecondsSinceEpoch ~/ 1000;

  // Get end of week (Sunday)
  DateTime endOfWeek = startOfWeek.add(
    Duration(
      days: 6,
      hours: 23,
      minutes: 59,
      seconds: 59,
      milliseconds: 999,
      microseconds: 999,
    ),
  );
  int endOfWeekUnix = endOfWeek.millisecondsSinceEpoch ~/ 1000;

  return UnixDateRange(
    startTime: startOfWeekUnix,
    endTime: endOfWeekUnix,
  );
}

UnixDateRange convertToUnixMonthRange(DateTime date) {
  // Use seconds since epoch (minimum number of zeros at the end)
  int startOfMonth =
      DateTime(date.year, date.month, 1).millisecondsSinceEpoch ~/ 1000;

  // Get next month
  DateTime nextMonth = (date.month < 12)
      ? DateTime(date.year, date.month + 1, 1)
      : DateTime(date.year + 1, 1, 1);
  int endOfMonth =
      nextMonth.subtract(const Duration(seconds: 1)).millisecondsSinceEpoch ~/
          1000;

  return UnixDateRange(
    startTime: startOfMonth,
    endTime: endOfMonth,
  );
}

UnixDateRange convertDateRangeToUnixDateRange({
  required DateTime startDate,
  required DateTime endDate,
}) {
  int startOfDay =
      DateTime(startDate.year, startDate.month, 1).millisecondsSinceEpoch ~/
          1000;
  int endOfDay =
      DateTime(endDate.year, endDate.month, 1).millisecondsSinceEpoch ~/ 1000;

  return UnixDateRange(
    startTime: startOfDay,
    endTime: endOfDay,
  );
}
